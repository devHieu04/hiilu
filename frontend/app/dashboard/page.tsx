"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/contexts/AuthContext";
import { DashboardLayout } from "@/components/dashboard/DashboardLayout";
import { CardItem } from "@/components/dashboard/CardItem";
import { cardsService, Card } from "@/lib/cards";
import CardShare from "@/components/cards/CardShare";
import Image from "next/image";

export default function DashboardPage() {
  const { user, token, isLoading: authLoading } = useAuth();
  const router = useRouter();
  const [cards, setCards] = useState<Card[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState("");
  const [shareCard, setShareCard] = useState<Card | null>(null);
  const [isShareOpen, setIsShareOpen] = useState(false);



  useEffect(() => {
    if (!authLoading) {
      if (!user || !token) {
        router.push("/login");
        return;
      }
      loadCards();
    }
  }, [user, token, authLoading, router]);

  const loadCards = async () => {
    if (!token) return;
    try {
      setIsLoading(true);
      const data = await cardsService.getCards(token);
      setCards(data);
    } catch (err: any) {
      setError(err.message || "Không thể tải danh sách thẻ");
    } finally {
      setIsLoading(false);
    }
  };

  const handleDelete = async (cardId: string) => {
    if (!token) return;
    if (!confirm("Bạn có chắc chắn muốn xóa thẻ này?")) return;

    try {
      await cardsService.deleteCard(cardId, token);
      await loadCards();
    } catch (err: any) {
      alert(err.message || "Không thể xóa thẻ");
    }
  };

  const handleEdit = (card: Card) => {
    router.push(`/dashboard/cards/edit/${card._id}`);
  };

  // const handleShare = async (card: Card) => {
  //   try {
  //     if (!card.shareUuid) {
  //       alert("Thẻ này chưa có link chia sẻ. Vui lòng tải lại trang.");
  //       return;
  //     }

  //     const cardUrl = `${window.location.origin}/card/${card.shareUuid}`;
  //     await navigator.clipboard.writeText(cardUrl);
  //     alert("Đã sao chép link thẻ!");
  //   } catch (err: any) {
  //     alert("Không thể sao chép link. Vui lòng thử lại.");
  //   }
  // };

  const handleShare = (card: Card) => {
  if (!card.shareUuid || !card.qrCodeUrl) {
    alert("Thẻ này chưa sẵn sàng để chia sẻ.");
    return;
  }
  setShareCard(card);
  setIsShareOpen(true);
};


  if (authLoading || isLoading) {
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
      <div className="space-y-8">
        {/* QR Code Section */}
        <div className="rounded-[24px] bg-gradient-to-br from-[#455A6B] to-[#808F9B] p-6 sm:p-8">
          <div className="grid gap-6 md:grid-cols-2 md:items-center">
            <div className="space-y-4">
              <h2 className="text-2xl font-semibold text-[#fafafa] sm:text-xl">
                Tải ngay ứng dụng HiiLu
              </h2>
              <p className="text-sm leading-relaxed text-[#DDDDDD] sm:text-base">
                Quét mã QR để cài đặt và đồng bộ thẻ của bạn trên ứng dụng.
              </p>
            </div>
            <div className="flex items-center justify-center">
              <div className="rounded-lg bg-white p-4 shadow-lg">
                <div className="flex h-48 w-48 items-center justify-center rounded-lg border-2 border-dashed border-gray-300 text-sm text-gray-400">
                  mã QR
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Cards Grid */}
        {error && (
          <div className="rounded-lg bg-red-50 p-4 text-sm text-red-600">
            {error}
          </div>
        )}

        {cards.length === 0 ? (
          <div className="rounded-lg border-2 border-dashed border-gray-300 bg-white p-12 text-center">
            <span className="material-icons mb-4 text-6xl text-gray-400">
              credit_card
            </span>
            <h3 className="mb-2 text-lg font-semibold text-gray-900">
              Chưa có thẻ nào
            </h3>
            <p className="mb-6 text-sm text-gray-600">
              Tạo thẻ đầu tiên của bạn để bắt đầu chia sẻ thông tin
            </p>
            <Link
              href="/dashboard/cards/create"
              className="inline-block rounded-lg bg-[#455A6B] px-6 py-3 text-sm font-semibold text-white transition-colors hover:bg-[#374a5a]"
            >
              Tạo thẻ mới
            </Link>
          </div>
        ) : (
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {cards.map((card) => (
              <CardItem
                key={card._id}
                card={card}
                onEdit={handleEdit}
                onDelete={handleDelete}
                onShare={handleShare}
              />
            ))}
          </div>
        )}
      </div>
      {isShareOpen && shareCard && (
  <CardShare
    card={shareCard}
    onClose={() => {
      setIsShareOpen(false);
      setShareCard(null);
    }}
  />
)}

    </DashboardLayout>
  );
}
