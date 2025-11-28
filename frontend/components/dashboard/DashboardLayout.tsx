'use client';

import Image from 'next/image';
import Link from 'next/link';
import { useRouter, usePathname } from 'next/navigation';
import { useAuth } from '@/contexts/AuthContext';
import { ReactNode, useState } from 'react';

interface DashboardLayoutProps {
  children: ReactNode;
}

const navItems = [
  { label: 'Thẻ của tôi', href: '/dashboard', icon: 'credit_card' },
  { label: 'Tài khoản', href: '/dashboard/account', icon: 'person' },
  { label: 'Hỗ trợ', href: '/dashboard/support', icon: 'help' },
];

export function DashboardLayout({ children }: DashboardLayoutProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const { user, logout } = useAuth();
  const router = useRouter();
  const pathname = usePathname();

  const handleLogout = () => {
    logout();
    router.push('/');
  };

  return (
    <div className="flex min-h-screen bg-gray-50">
      {/* Sidebar */}
      <aside className="hidden w-64 border-r border-gray-200 bg-white lg:block">
        <div className="flex h-full flex-col p-6">
          <div className="mb-8">
            <div className="flex items-center gap-2">
              <Image
                src="/assets/web/Group 4.png"
                alt="HiiLu"
                width={92}
                height={32}
                className="h-8 w-auto object-contain"
              />
              <span className="text-xl font-semibold text-gray-900">HIILU</span>
            </div>
          </div>

          <nav className="flex-1 space-y-2">
            {navItems.map((item) => {
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex items-center gap-3 rounded-lg px-4 py-3 text-sm font-medium transition-colors ${
                    isActive
                      ? 'bg-gray-100 text-[#455A6B]'
                      : 'text-gray-600 hover:bg-gray-50 hover:text-[#455A6B]'
                  }`}
                >
                  <span className="material-icons text-xl">{item.icon}</span>
                  <span>{item.label}</span>
                </Link>
              );
            })}
          </nav>
        </div>
      </aside>

      {/* Main Content */}
      <div className="flex flex-1 flex-col">
        {/* Header */}
        <header className="sticky top-0 z-10 border-b border-gray-200 bg-white">
          <div className="flex items-center justify-between gap-4 px-4 py-4 sm:px-6">
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2 lg:hidden">
                <Image
                  src="/assets/web/Group 4.png"
                  alt="HiiLu"
                  width={92}
                  height={32}
                  className="h-6 w-auto object-contain"
                />
                <span className="text-lg font-semibold text-gray-900">HIILU</span>
              </div>
              <Link
                href="/dashboard/cards/create"
                className="flex items-center gap-2 rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-50"
              >
                <span className="material-icons text-lg">add</span>
                <span>Tạo thẻ mới</span>
              </Link>
            </div>

            <div className="flex flex-1 items-center justify-end gap-4">
              <div className="hidden flex-1 max-w-md items-center gap-2 rounded-lg border border-gray-300 bg-gray-50 px-4 py-2 sm:flex">
                <span className="material-icons text-lg text-gray-400">search</span>
                <input
                  type="text"
                  placeholder="Tìm kiếm..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="flex-1 bg-transparent text-sm outline-none placeholder:text-gray-400"
                />
              </div>
              <button
                onClick={handleLogout}
                className="rounded-lg bg-[#455A6B] px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-[#374a5a]"
              >
                Đăng xuất
              </button>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="flex-1 p-4 sm:p-6 lg:p-8">{children}</main>
      </div>
    </div>
  );
}
