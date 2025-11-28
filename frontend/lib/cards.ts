import { api } from './api';

export interface Card {
  _id: string;
  userId: string;
  cardName: string;
  ownerName: string;
  email?: string;
  phoneNumber?: string;
  company?: string;
  address?: string;
  description?: string;
  avatarUrl?: string;
  coverImageUrl?: string;
  theme?: {
    color?: string;
    icon?: string;
  };
  links?: Array<{
    title: string;
    url: string;
    icon?: string;
  }>;
  qrCodeUrl?: string;
  isActive: boolean;
  viewCount: number;
  createdAt: string;
  updatedAt: string;
}

export interface CreateCardRequest {
  cardName: string;
  ownerName: string;
  avatarUrl?: string;
  coverImageUrl?: string;
  theme?: {
    color?: string;
    icon?: string;
  };
  links?: Array<{
    title: string;
    url: string;
    icon?: string;
  }>;
  address?: string;
  company?: string;
  description?: string;
  phoneNumber?: string;
  email?: string;
}

export interface UpdateCardRequest {
  cardName?: string;
  ownerName?: string;
  avatarUrl?: string;
  coverImageUrl?: string;
  theme?: {
    color?: string;
    icon?: string;
  };
  links?: Array<{
    title: string;
    url: string;
    icon?: string;
  }>;
  address?: string;
  company?: string;
  description?: string;
  phoneNumber?: string;
  email?: string;
}

export const cardsService = {
  async getCards(token: string): Promise<Card[]> {
    return api.get<Card[]>('/cards', { token });
  },

  async getCard(id: string): Promise<Card> {
    return api.get<Card>(`/cards/${id}`);
  },

  async createCard(
    data: CreateCardRequest,
    token: string,
    avatarFile?: File,
    coverImageFile?: File
  ): Promise<Card> {
    const formData = new FormData();

    // Add text fields
    formData.append('cardName', data.cardName);
    formData.append('ownerName', data.ownerName);
    if (data.email) formData.append('email', data.email);
    if (data.phoneNumber) formData.append('phoneNumber', data.phoneNumber);
    if (data.company) formData.append('company', data.company);
    if (data.address) formData.append('address', data.address);
    if (data.description) formData.append('description', data.description);

    // Add files
    if (avatarFile) {
      formData.append('avatar', avatarFile);
    }
    if (coverImageFile) {
      formData.append('coverImage', coverImageFile);
    }

    // Add theme as JSON string - ensure it's a valid object
    if (data.theme) {
      const themeObj: any = {};
      if (data.theme.color) themeObj.color = data.theme.color;
      if (data.theme.icon) themeObj.icon = data.theme.icon;
      // Only append if theme object has at least one property
      if (Object.keys(themeObj).length > 0) {
        formData.append('theme', JSON.stringify(themeObj));
      }
    }

    // Add links as JSON string of an ARRAY
    if (data.links && Array.isArray(data.links) && data.links.length > 0) {
      // Filter and validate links
      const validLinks = data.links
        .filter((link) => link && typeof link === 'object' && link.title && link.url)
        .map((link) => ({
          title: link.title,
          url: link.url,
          ...(link.icon && { icon: link.icon }),
        }));

      // Append as 'links' with JSON string of ARRAY
      if (validLinks.length > 0) {
        formData.append('links', JSON.stringify(validLinks));
      }
    }

    // Use fetch directly for FormData
    const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080/api/v1';
    const response = await fetch(`${API_URL}/cards`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        // Don't set Content-Type, browser will set it with boundary
      },
      body: formData,
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({
        message: 'An error occurred',
      }));
      const errorMessage = Array.isArray(error.message)
        ? error.message.join(', ')
        : error.message || `HTTP error! status: ${response.status}`;
      throw new Error(errorMessage);
    }

    return response.json();
  },

  async updateCard(id: string, data: UpdateCardRequest, token: string): Promise<Card> {
    return api.patch<Card>(`/cards/${id}`, data, { token });
  },

  async deleteCard(id: string, token: string): Promise<{ message: string }> {
    return api.delete<{ message: string }>(`/cards/${id}`, { token });
  },
};
