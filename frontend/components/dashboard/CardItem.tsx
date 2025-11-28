'use client';

import { Card } from '@/lib/cards';

interface CardItemProps {
  card: Card;
  onEdit: (card: Card) => void;
  onDelete: (cardId: string) => void;
  onShare: (card: Card) => void;
}

const themeColors: Record<string, string> = {
  '#0ea5e9': 'bg-blue-50',
  '#fbbf24': 'bg-yellow-50',
  '#f472b6': 'bg-pink-50',
  '#34d399': 'bg-green-50',
  default: 'bg-gray-50',
};

export function CardItem({ card, onEdit, onDelete, onShare }: CardItemProps) {
  const bgColor = card.theme?.color
    ? themeColors[card.theme.color] || themeColors.default
    : themeColors.default;

  const getInitials = (name: string) => {
    return name
      .split(' ')
      .map((n) => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  return (
    <div className={`relative rounded-[24px] ${bgColor} p-6 shadow-lg`}>
      <button
        onClick={() => onShare(card)}
        className="absolute right-4 top-4 rounded-full bg-white/80 p-2 text-[#455A6B] transition-colors hover:bg-white"
        aria-label="Share card"
      >
        <span className="material-icons text-lg">share</span>
      </button>

      <div className="flex flex-col items-center space-y-4">
        {card.avatarUrl ? (
          <img
            src={card.avatarUrl}
            alt={card.ownerName}
            className="h-[120px] w-[120px] rounded-full object-cover"
          />
        ) : (
          <div className="flex h-[120px] w-[120px] items-center justify-center rounded-full bg-white text-2xl font-semibold text-gray-600">
            {getInitials(card.ownerName)}
          </div>
        )}

        <h3 className="text-xl font-semibold text-gray-900">{card.ownerName}</h3>

        <div className="mt-auto flex w-full gap-3">
          <button
            onClick={() => onDelete(card._id)}
            className="flex-1 rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-50"
          >
            Xoá thẻ
          </button>
          <button
            onClick={() => onEdit(card)}
            className="flex-1 rounded-lg bg-[#455A6B] px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-[#374a5a]"
          >
            Chỉnh sửa
          </button>
        </div>
      </div>
    </div>
  );
}
