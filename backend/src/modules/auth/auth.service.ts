import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { User, UserDocument, UserRole } from '../users/schemas/user.schema';
import {
  LoginHistory,
  LoginHistoryDocument,
  PlatformType,
} from './schemas/login-history.schema';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { ChangePasswordDto } from './dto/change-password.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    @InjectModel(LoginHistory.name)
    private loginHistoryModel: Model<LoginHistoryDocument>,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async register(registerDto: RegisterDto) {
    const { email, name, password } = registerDto;

    // Check if user exists
    const existingUser = await this.userModel.findOne({ email });
    if (existingUser) {
      throw new ConflictException('Email already registered');
    }

    // Check if this is the first user
    const userCount = await this.userModel.countDocuments();
    const isFirstUser = userCount === 0;

    // Create new user
    const user = new this.userModel({
      email,
      name,
      password,
      role: isFirstUser ? UserRole.ADMIN : UserRole.USER,
    });

    await user.save();

    // Generate token
    const token = this.generateToken(user);

    return {
      user: this.sanitizeUser(user),
      token,
    };
  }

  async login(
    loginDto: LoginDto,
    platform: PlatformType,
    ipAddress: string,
    userAgent: string,
  ) {
    const { email, password } = loginDto;

    // Find user
    const user = await this.userModel.findOne({ email });

    if (!user) {
      await this.logFailedLogin(null, platform, ipAddress, userAgent, 'User not found');
      throw new UnauthorizedException('Invalid credentials');
    }

    // Check password
    const isPasswordValid = await (user as any).comparePassword(password);

    if (!isPasswordValid) {
      await this.logFailedLogin(user._id, platform, ipAddress, userAgent, 'Invalid password');
      throw new UnauthorizedException('Invalid credentials');
    }

    if (!user.isActive) {
      await this.logFailedLogin(user._id, platform, ipAddress, userAgent, 'Account inactive');
      throw new UnauthorizedException('Account is inactive');
    }

    // Log successful login
    await this.logSuccessfulLogin(user._id, platform, ipAddress, userAgent);

    // Generate token
    const token = this.generateToken(user);

    return {
      user: this.sanitizeUser(user),
      token,
    };
  }

  async getLoginHistory(userId: string, limit: number = 10) {
    return this.loginHistoryModel
      .find({ userId })
      .sort({ createdAt: -1 })
      .limit(limit)
      .exec();
  }

  async getAllUsers() {
    const users = await this.userModel
      .find()
      .select('-password')
      .sort({ createdAt: -1 })
      .exec();

    return users;
  }

  async updateProfile(userId: string, updateProfileDto: UpdateProfileDto) {
    const { name, email } = updateProfileDto;

    // If email is being updated, check if it's already in use
    if (email) {
      const existingUser = await this.userModel.findOne({
        email,
        _id: { $ne: userId },
      });

      if (existingUser) {
        throw new ConflictException('Email already in use');
      }
    }

    const updatedUser = await this.userModel
      .findByIdAndUpdate(
        userId,
        { $set: { name, email } },
        { new: true, runValidators: true },
      )
      .exec();

    if (!updatedUser) {
      throw new UnauthorizedException('User not found');
    }

    return this.sanitizeUser(updatedUser);
  }

  async changePassword(userId: string, changePasswordDto: ChangePasswordDto) {
    const { currentPassword, newPassword, confirmPassword } = changePasswordDto;

    // Check if new password and confirm password match
    if (newPassword !== confirmPassword) {
      throw new BadRequestException('New password and confirm password do not match');
    }

    // Find user
    const user = await this.userModel.findById(userId).exec();

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    // Verify current password
    const isPasswordValid = await (user as any).comparePassword(currentPassword);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    // Check if new password is same as current password
    if (currentPassword === newPassword) {
      throw new BadRequestException('New password must be different from current password');
    }

    // Update password (will be hashed by pre-save hook)
    user.password = newPassword;
    await user.save();

    return {
      message: 'Password changed successfully',
    };
  }

  private generateToken(user: UserDocument): string {
    const payload = {
      sub: user._id.toString(),
      email: user.email,
    };

    return this.jwtService.sign(payload);
  }

  private sanitizeUser(user: UserDocument) {
    const userObject = user.toObject();
    delete userObject.password;
    return userObject;
  }

  private async logSuccessfulLogin(
    userId: any,
    platform: PlatformType,
    ipAddress: string,
    userAgent: string,
  ) {
    await this.loginHistoryModel.create({
      userId,
      platform,
      ipAddress,
      userAgent,
      isSuccessful: true,
    });
  }

  private async logFailedLogin(
    userId: any,
    platform: PlatformType,
    ipAddress: string,
    userAgent: string,
    reason: string,
  ) {
    await this.loginHistoryModel.create({
      userId,
      platform,
      ipAddress,
      userAgent,
      isSuccessful: false,
      failureReason: reason,
    });
  }
}
