'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/contexts/AuthContext';
import { DashboardLayout } from '@/components/dashboard/DashboardLayout';
import { authService } from '@/lib/auth';

export default function AccountPage() {
  const { user, token, isLoading, updateProfile } = useAuth();
  const router = useRouter();

  // Profile form state
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [isSavingProfile, setIsSavingProfile] = useState(false);
  const [profileError, setProfileError] = useState('');
  const [profileSuccess, setProfileSuccess] = useState('');

  // Password form state
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isChangingPassword, setIsChangingPassword] = useState(false);
  const [passwordError, setPasswordError] = useState('');
  const [passwordSuccess, setPasswordSuccess] = useState('');

  useEffect(() => {
    if (!isLoading && !user) {
      router.push('/login');
    }
    if (user) {
      setName(user.name || '');
      setEmail(user.email || '');
    }
  }, [user, isLoading, router]);

  const handleSaveProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!token) return;

    setProfileError('');
    setProfileSuccess('');
    setIsSavingProfile(true);

    try {
      await updateProfile({ name, email });
      setProfileSuccess('Đã cập nhật thông tin thành công!');
      setTimeout(() => setProfileSuccess(''), 3000);
    } catch (err: any) {
      if (err.message?.includes('409') || err.message?.includes('already')) {
        setProfileError('Email này đã được sử dụng. Vui lòng chọn email khác.');
      } else {
        setProfileError(err.message || 'Không thể cập nhật thông tin. Vui lòng thử lại.');
      }
    } finally {
      setIsSavingProfile(false);
    }
  };

  const handleChangePassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!token) return;

    setPasswordError('');
    setPasswordSuccess('');

    // Validation
    if (newPassword !== confirmPassword) {
      setPasswordError('Mật khẩu mới và xác nhận mật khẩu không khớp.');
      return;
    }

    setIsChangingPassword(true);

    try {
      await authService.changePassword(
        {
          currentPassword,
          newPassword,
          confirmPassword,
        },
        token
      );
      setPasswordSuccess('Đã đổi mật khẩu thành công!');
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
      setTimeout(() => setPasswordSuccess(''), 3000);
    } catch (err: any) {
      if (err.message?.includes('incorrect') || err.message?.includes('401')) {
        setPasswordError('Mật khẩu hiện tại không đúng.');
      } else if (err.message?.includes('same')) {
        setPasswordError('Mật khẩu mới phải khác mật khẩu hiện tại.');
      } else if (err.message?.includes('match')) {
        setPasswordError('Mật khẩu mới và xác nhận mật khẩu không khớp.');
      } else {
        setPasswordError(err.message || 'Không thể đổi mật khẩu. Vui lòng thử lại.');
      }
    } finally {
      setIsChangingPassword(false);
    }
  };

  if (isLoading) {
    return (
      <DashboardLayout>
        <div className="flex items-center justify-center py-12">
          <div className="text-center">
            <div className="mb-4 inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-[#455A6B] border-r-transparent"></div>
            <p className="text-gray-600">Đang tải...</p>
          </div>
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout>
      <div className="flex justify-center">
        <div className="w-full max-w-4xl space-y-8">
          <div>
            <h1 className="text-3xl font-semibold text-gray-900">Tài khoản</h1>
            <p className="mt-2 text-sm text-gray-600">
              Quản lý thông tin cá nhân và bảo mật tài khoản của bạn
            </p>
          </div>

          <div className="rounded-[24px] border border-gray-200 bg-white p-6 sm:p-8">
          {/* Profile Section */}
          <div className="mb-12 space-y-6">
            <h2 className="text-xl font-semibold text-gray-900">Hồ sơ tài khoản</h2>

            <form onSubmit={handleSaveProfile} className="space-y-5">
              <div>
                <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-2">
                  Tên
                </label>
                <input
                  type="text"
                  id="name"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  required
                  minLength={2}
                  className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                />
              </div>

              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                  Email
                </label>
                <input
                  type="email"
                  id="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                />
              </div>

              {profileError && (
                <div className="rounded-lg bg-red-50 p-3 text-sm text-red-600">{profileError}</div>
              )}

              {profileSuccess && (
                <div className="rounded-lg bg-green-50 p-3 text-sm text-green-600">
                  {profileSuccess}
                </div>
              )}

              <div className="flex justify-end">
                <button
                  type="submit"
                  disabled={isSavingProfile}
                  className="rounded-lg bg-[#8b5cf6] px-6 py-3 text-sm font-semibold text-white transition-colors hover:bg-[#7c3aed] disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {isSavingProfile ? 'Đang lưu...' : 'Lưu thông tin'}
                </button>
              </div>
            </form>
          </div>

          {/* Password Section */}
          <div className="space-y-6 border-t border-gray-200 pt-8">
            <h2 className="text-xl font-semibold text-gray-900">Bảo mật tài khoản</h2>

            <form onSubmit={handleChangePassword} className="space-y-5">
              <div>
                <label
                  htmlFor="currentPassword"
                  className="block text-sm font-medium text-gray-700 mb-2"
                >
                  Mật khẩu hiện tại
                </label>
                <input
                  type="password"
                  id="currentPassword"
                  value={currentPassword}
                  onChange={(e) => setCurrentPassword(e.target.value)}
                  placeholder="Nhập mật khẩu hiện tại"
                  required
                  className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                />
              </div>

              <div>
                <label
                  htmlFor="newPassword"
                  className="block text-sm font-medium text-gray-700 mb-2"
                >
                  Mật khẩu mới
                </label>
                <input
                  type="password"
                  id="newPassword"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  placeholder="Nhập mật khẩu mới"
                  required
                  minLength={6}
                  className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                />
                <p className="mt-1 text-xs text-gray-500">
                  Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường và số
                </p>
              </div>

              <div>
                <label
                  htmlFor="confirmPassword"
                  className="block text-sm font-medium text-gray-700 mb-2"
                >
                  Xác nhận mật khẩu mới
                </label>
                <input
                  type="password"
                  id="confirmPassword"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  placeholder="Nhập lại mật khẩu mới"
                  required
                  minLength={6}
                  className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                />
              </div>

              {passwordError && (
                <div className="rounded-lg bg-red-50 p-3 text-sm text-red-600">
                  {passwordError}
                </div>
              )}

              {passwordSuccess && (
                <div className="rounded-lg bg-green-50 p-3 text-sm text-green-600">
                  {passwordSuccess}
                </div>
              )}

              <div className="flex justify-end">
                <button
                  type="submit"
                  disabled={isChangingPassword}
                  className="rounded-lg bg-[#8b5cf6] px-6 py-3 text-sm font-semibold text-white transition-colors hover:bg-[#7c3aed] disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {isChangingPassword ? 'Đang đổi...' : 'Đổi mật khẩu'}
                </button>
              </div>
            </form>
          </div>
        </div>
        </div>
      </div>
    </DashboardLayout>
  );
}
