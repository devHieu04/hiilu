import type { NextConfig } from 'next';

// Get API URL from environment
const API_URL = process.env.NEXT_PUBLIC_API_URL || 'https://api.hilu.pics/api/v1';
const API_BASE_URL = API_URL.replace('/api/v1', '');

// Parse API URL to get protocol, hostname, and port
const parseApiUrl = (url: string) => {
  try {
    const urlObj = new URL(url);
    return {
      protocol: urlObj.protocol.replace(':', '') as 'http' | 'https',
      hostname: urlObj.hostname,
      port: urlObj.port || (urlObj.protocol === 'https:' ? '443' : '80'),
    };
  } catch {
    // Fallback for production
    return {
      protocol: 'https' as const,
      hostname: 'api.hilu.pics',
      port: '443',
    };
  }
};

const apiConfig = parseApiUrl(API_BASE_URL);

const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
  compress: true,
  output: 'standalone',

  env: {
    API_URL,
  },

  // Image optimization
  images: {
    formats: ['image/avif', 'image/webp'],
    remotePatterns: [
      {
        protocol: apiConfig.protocol,
        hostname: apiConfig.hostname,
        ...(apiConfig.port && apiConfig.port !== '80' && apiConfig.port !== '443'
          ? { port: apiConfig.port }
          : {}),
        pathname: '/uploads/**',
      },
    ],
  },

  // Security headers
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-DNS-Prefetch-Control',
            value: 'on',
          },
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=63072000; includeSubDomains; preload',
          },
          {
            key: 'X-Frame-Options',
            value: 'SAMEORIGIN',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin',
          },
        ],
      },
    ];
  },
};

export default nextConfig;
