import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { AuthProvider } from '@/contexts/AuthContext';

const inter = Inter({ subsets: ['latin', 'vietnamese'] });

export const metadata: Metadata = {
  title: 'HiiLu - Smart Digital Card',
  description:
    'Trong thế giới nơi mọi thứ đều đang được số hóa, HiiLu mang đến cách kết nối hoàn toàn mới giúp bạn tạo dấu ấn chuyên nghiệp và bền vững hơn bao giờ hết.',
  keywords: [
    'smart card',
    'digital card',
    'business card',
    'networking',
    'HiiLu',
  ],
  authors: [{ name: 'HiiLu Team' }],
  viewport: 'width=device-width, initial-scale=1',
  themeColor: '#0ea5e9',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="vi">
      <head>
        <link
          rel="stylesheet"
          href="https://fonts.googleapis.com/icon?family=Material+Icons"
        />
      </head>
      <body className={`${inter.className} antialiased`}>
        <AuthProvider>{children}</AuthProvider>
      </body>
    </html>
  );
}
