'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import { CardView } from '@/components/cards/CardView';
import { cardsService, Card } from '@/lib/cards';

export default function CardViewPage() {
  const params = useParams();
  const uuid = params.uuid as string;
  const [card, setCard] = useState<Card | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    // Check if device is mobile
    const checkMobile = () => {
      const userAgent = navigator.userAgent || navigator.vendor || (window as any).opera;
      const isMobileDevice = /android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(
        userAgent.toLowerCase()
      );
      setIsMobile(isMobileDevice);
      return isMobileDevice;
    };

    if (!checkMobile()) {
      setError('Trang này chỉ có thể xem trên thiết bị di động');
      setIsLoading(false);
      return;
    }

    const loadCard = async () => {
      if (!uuid) return;
      try {
        setIsLoading(true);
        const cardData = await cardsService.getCardByUuid(uuid);
        setCard(cardData);
      } catch (err: any) {
        setError(err.message || 'Không thể tải thông tin thẻ');
      } finally {
        setIsLoading(false);
      }
    };

    loadCard();
  }, [uuid]);

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="mb-4 inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-[#455A6B] border-r-transparent"></div>
          <p className="text-gray-600">Đang tải...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50 p-4">
        <div className="rounded-lg bg-white p-6 text-center shadow-lg">
          <span className="material-icons mb-4 text-6xl text-red-500">error</span>
          <h2 className="mb-2 text-xl font-semibold text-gray-900">Lỗi</h2>
          <p className="text-gray-600">{error}</p>
        </div>
      </div>
    );
  }

  if (!card) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50 p-4">
        <div className="rounded-lg bg-white p-6 text-center shadow-lg">
          <span className="material-icons mb-4 text-6xl text-gray-400">credit_card</span>
          <h2 className="mb-2 text-xl font-semibold text-gray-900">Không tìm thấy thẻ</h2>
          <p className="text-gray-600">Thẻ này không tồn tại hoặc đã bị xóa</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      <CardView card={card} />
    </div>
  );
}
