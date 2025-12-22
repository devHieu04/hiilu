'use client';

import Image from 'next/image';
import Link from 'next/link';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { LoginModal } from '@/components/modals/LoginModal';
import { RegisterModal } from '@/components/modals/RegisterModal';
import { useAuth } from '@/contexts/AuthContext';

const navItems = [
  { label: 'Home.', href: '#hero' },
  { label: 'Giới thiệu', href: '#about' },
  { label: 'Tính năng', href: '#features' },
  { label: 'Hướng dẫn', href: '#guide' },
  { label: "FAQ's", href: '#faq' },
  { label: 'Liên hệ', href: '#contact' },
];

export function Navbar() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isLoginOpen, setIsLoginOpen] = useState(false);
  const [isRegisterOpen, setIsRegisterOpen] = useState(false);
  const { user } = useAuth();
  const router = useRouter();

  const handleLoginClick = (e?: React.MouseEvent) => {
    e?.preventDefault();
    // On mobile (hidden modal), navigate to login page
    // On desktop (visible modal), show modal
    const isMobile = typeof window !== 'undefined' && window.innerWidth < 768;
    if (isMobile) {
      router.push('/login');
    } else {
      setIsLoginOpen(true);
    }
  };

  const handleRegisterClick = (e?: React.MouseEvent) => {
    e?.preventDefault();
    // On mobile (hidden modal), navigate to register page
    // On desktop (visible modal), show modal
    const isMobile = typeof window !== 'undefined' && window.innerWidth < 768;
    if (isMobile) {
      router.push('/register');
    } else {
      setIsRegisterOpen(true);
    }
  };

  return (
    <header className="sticky top-0 z-40 w-full border-b border-white/40 bg-transparent backdrop-blur-xl">
      <div className="container-default flex items-center justify-between gap-4 py-3 sm:py-4">
        <div className="flex flex-col items-center gap-0.5 sm:gap-1">
          <Image
            src="/assets/web/Group 4.png"
            alt="HiiLu"
            width={92}
            height={32}
            className="h-6 w-auto object-contain sm:h-8"
            priority
          />
          {/* <span className="text-sm font-semibold tracking-[0.3px] text-gray-900 sm:text-lg">
            HiiLu
          </span> */}
        </div>

        <nav className="hidden items-center gap-6 text-xs font-medium tracking-[0.2px] text-[#4a4a4a] lg:flex lg:gap-8 lg:text-sm">
          {navItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="transition-colors hover:text-[#0f9ec8]"
            >
              {item.label}
            </Link>
          ))}
        </nav>

        <div className="flex items-center gap-2 sm:gap-4">
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="flex flex-col gap-1.5 rounded-lg p-2 lg:hidden"
            aria-label="Toggle menu"
          >
            <span
              className={`h-0.5 w-6 bg-gray-900 transition-all ${
                isMenuOpen ? 'rotate-45 translate-y-2' : ''
              }`}
            />
            <span
              className={`h-0.5 w-6 bg-gray-900 transition-all ${
                isMenuOpen ? 'opacity-0' : ''
              }`}
            />
            <span
              className={`h-0.5 w-6 bg-gray-900 transition-all ${
                isMenuOpen ? '-rotate-45 -translate-y-2' : ''
              }`}
            />
          </button>

          {user ? (
            <>
              <span className="hidden text-sm text-gray-700 lg:inline">{user.name}</span>
              <button
                onClick={() => router.push('/dashboard')}
                className="inline-flex rounded-full border border-[#6ec3f4] px-3 py-1.5 text-[10px] font-semibold text-[#088f9f] shadow-inner shadow-white/60 transition hover:bg-white sm:px-4 sm:py-2 sm:text-xs lg:hidden"
              >
                Vào Dashboard
              </button>
              <button
                onClick={() => router.push('/dashboard')}
                className="hidden rounded-full bg-gradient-to-r from-[#00BFA6] to-[#6ec3f4] px-6 py-2 text-sm font-semibold text-white shadow-[0_12px_30px_rgba(76,212,194,0.4)] transition hover:opacity-90 lg:inline-flex"
              >
                Vào Dashboard
              </button>
            </>
          ) : (
            <>
              <button
                onClick={handleLoginClick}
                className="inline-flex rounded-full border border-[#6ec3f4] px-3 py-1.5 text-[10px] font-semibold text-[#088f9f] shadow-inner shadow-white/60 transition hover:bg-white sm:px-4 sm:py-2 sm:text-xs lg:hidden"
              >
                Đăng nhập
              </button>
              <button
                onClick={handleLoginClick}
                className="hidden rounded-full bg-gradient-to-r from-[#4ad5c2] to-[#6ec3f4] px-6 py-2 text-sm font-semibold text-white shadow-[0_12px_30px_rgba(76,212,194,0.4)] transition hover:opacity-90 lg:inline-flex"
              >
                Đăng nhập
              </button>
            </>
          )}
        </div>
      </div>

      {/* Mobile Menu */}
      {isMenuOpen && (
        <div className="border-t border-white/40 bg-white/95 backdrop-blur-xl lg:hidden">
          <nav className="container-default flex flex-col gap-1 py-4">
            {navItems.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setIsMenuOpen(false)}
                className="rounded-lg px-4 py-2 text-sm font-medium text-[#4a4a4a] transition-colors hover:bg-gray-100 hover:text-[#0f9ec8]"
              >
                {item.label}
              </Link>
            ))}
          </nav>
        </div>
      )}

      <LoginModal
        isOpen={isLoginOpen}
        onClose={() => setIsLoginOpen(false)}
        onSwitchToRegister={() => setIsRegisterOpen(true)}
      />
      <RegisterModal
        isOpen={isRegisterOpen}
        onClose={() => setIsRegisterOpen(false)}
        onSwitchToLogin={() => setIsLoginOpen(true)}
      />
    </header>
  );
}
