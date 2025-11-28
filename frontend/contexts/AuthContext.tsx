'use client';

import { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { authService, AuthResponse, UpdateProfileRequest } from '@/lib/auth';

interface User {
  _id: string;
  email: string;
  name: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

interface AuthContextType {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, name: string, password: string) => Promise<void>;
  updateProfile: (data: UpdateProfileRequest) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Load token from localStorage on mount
    const storedToken = localStorage.getItem('token');
    if (storedToken) {
      setToken(storedToken);
      // Verify token by getting user info
      authService
        .getMe(storedToken)
        .then((userData) => {
          setUser(userData as User);
        })
        .catch(() => {
          // Token invalid, remove it
          localStorage.removeItem('token');
          setToken(null);
        })
        .finally(() => {
          setIsLoading(false);
        });
    } else {
      setIsLoading(false);
    }
  }, []);

  const login = async (email: string, password: string) => {
    const response = await authService.login({ email, password });
    setToken(response.token);
    setUser(response.user);
    localStorage.setItem('token', response.token);
  };

  const register = async (email: string, name: string, password: string) => {
    const response = await authService.register({ email, name, password });
    setToken(response.token);
    setUser(response.user);
    localStorage.setItem('token', response.token);
  };

  const updateProfile = async (data: UpdateProfileRequest) => {
    if (!token) throw new Error('Not authenticated');
    const updatedUser = await authService.updateProfile(data, token);
    setUser(updatedUser as User);
  };

  const logout = () => {
    setToken(null);
    setUser(null);
    localStorage.removeItem('token');
  };

  return (
    <AuthContext.Provider value={{ user, token, isLoading, login, register, updateProfile, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
