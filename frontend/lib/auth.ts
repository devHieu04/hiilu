import { api } from './api';

export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  email: string;
  name: string;
  password: string;
}

export interface AuthResponse {
  user: {
    _id: string;
    email: string;
    name: string;
    isActive: boolean;
    createdAt: string;
    updatedAt: string;
  };
  token: string;
}

export interface UpdateProfileRequest {
  name?: string;
  email?: string;
}

export interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
  confirmPassword: string;
}

export const authService = {
  async login(data: LoginRequest): Promise<AuthResponse> {
    return api.post<AuthResponse>('/auth/login', data, {
      headers: {
        'x-platform': 'web',
      },
    });
  },

  async register(data: RegisterRequest): Promise<AuthResponse> {
    return api.post<AuthResponse>('/auth/register', data);
  },

  async getMe(token: string) {
    return api.get('/auth/me', { token });
  },

  async updateProfile(data: UpdateProfileRequest, token: string) {
    return api.patch('/auth/profile', data, { token });
  },

  async changePassword(data: ChangePasswordRequest, token: string) {
    return api.post<{ message: string }>('/auth/change-password', data, { token });
  },
};
