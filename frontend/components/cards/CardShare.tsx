"use client";

import { useState } from "react";
import Image from "next/image";

interface ShareCardModalProps {
    card: any;
    onClose: () => void;
}

export default function CardShare({ card, onClose }: ShareCardModalProps) {
    const bioLink = `${process.env.NEXT_PUBLIC_FRONTEND_URL}/card/${card.shareUuid}`;
    const [copyStatus, setCopyStatus] = useState<
        "idle" | "success" | "error"
    >("idle");

    const handleCopy = async () => {
        try {
            await navigator.clipboard.writeText(bioLink);
            setCopyStatus("success");
            setTimeout(() => setCopyStatus("idle"), 2000);
        } catch {
            setCopyStatus("error");
            setTimeout(() => setCopyStatus("idle"), 2000);
        }
    };

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
            <div className="relative h-[330px] w-[540px] rounded-xl bg-white p-6">
                {/* Close */}
                <button
  onClick={onClose}
  className="absolute right-6 top-6 text-gray-500 hover:text-gray-700"
>
  ✕
</button>


                {/* Header */}
                <div className="flex gap-6 items-start">
                    <div className="flex-1">
                        <h2 className="mt-8 ml-2 text-xl font-semibold text-[#455A6B]">
                            Quét mã QR để có thể xem <br /> danh thiếp của bạn
                        </h2>
                    </div>

                    {/* QR */}
                    <div className="flex h-[120px] w-[120px] mt-5 translate-x-[-36px] items-center justify-center rounded-lg border bg-gray-100">
                        <img
                            src={card.qrCodeUrl}
                            alt="QR Code danh thiếp"
                            className="h-full w-full object-contain"
                        />
                    </div>
                </div>


                <hr className="my-6" />

                {/* Link */}
                <div>
                    <p className="mb-2 ml-1 font-medium  text-[#455A6B]">
                        Đường dẫn đến danh thiếp của bạn
                    </p>

                    <div className="flex items-center gap-3">
                        <input
                            value={bioLink}
                            readOnly
                            className="flex-1 rounded-lg bg-gray-100 px-4 py-2 text-sm text-gray-700"
                        />

                        <button
                            onClick={handleCopy}
                            className="flex items-center gap-1 text-sm font-medium text-blue-600 hover:underline"
                        >
                            <Image
                                src="/assets/web/copy-left.png"
                                alt="Copy link"
                                width={14}
                                height={14}
                                className="shrink-0"
                            />
                            Sao chép link
                        </button>
                    </div>


                    {copyStatus === "success" && (
                        <p className="mt-2 ml-4 text-sm text-green-600">
                            Đã sao chép link thẻ!
                        </p>
                    )}

                    {copyStatus === "error" && (
                        <p className="mt-2 ml-4 text-sm text-red-600">
                            Không thể sao chép link. Vui lòng thử lại.
                        </p>
                    )}

                </div>
            </div>
        </div>
    );
}
