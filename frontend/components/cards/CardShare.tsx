// "use client";

// import Image from "next/image";

// interface ShareCardModalProps {
//   card: any;
//   onClose: () => void;
// }
// export default function CardShare({ card, onClose }: ShareCardModalProps) {

// //export default function ShareCardModal({ card, onClose }: ShareCardModalProps) {
//   const bioLink = `${process.env.NEXT_PUBLIC_FRONTEND_URL}/card/${card.shareUuid}`;

//   return (
//     <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
//       <div className="bg-white rounded-xl w-[600px] p-6 relative">
//         {/* Close */}
//         <button
//           onClick={onClose}
//           className="absolute top-4 right-4 text-gray-500"
//         >
//           ✕
//         </button>

//         {/* Header */}
//         <div className="flex gap-6">
//           <div className="flex-1">
//             <h2 className="text-xl font-semibold mb-2">
//               Quét mã QR để xem trang bio của bạn
//             </h2>
//           </div>

//           {/* QR */}
//           <div className="w-[160px] h-[160px] border rounded-lg flex items-center justify-center">
//             <img
//               src={card.qrCodeUrl}
//               alt="QR Code danh thiếp"
//               className="w-full h-full object-contain"
//             />
//           </div>
//         </div>

//         <hr className="my-6" />

//         {/* Link */}
//         <div>
//           <p className="font-medium mb-2">Đường dẫn đến bio của bạn</p>

//           <div className="flex items-center gap-3">
//             <input
//               value={bioLink}
//               readOnly
//               className="flex-1 bg-gray-100 rounded-lg px-4 py-2 text-sm"
//             />

//             <button
//               onClick={() => navigator.clipboard.writeText(bioLink)}
//               className="text-[#0055CC] text-sm font-medium"
//             >
//               Sao chép link
//             </button>
//           </div>
//         </div>
//       </div>
//     </div>
//   );
// }
"use client";

import { useState } from "react";
import Image from "next/image";

interface ShareCardModalProps {
  card: any;
  onClose: () => void;
}

export default function CardShare({ card, onClose }: ShareCardModalProps) {
  // Use window.location.origin as fallback if env variable is not set
  const frontendUrl =
    process.env.NEXT_PUBLIC_FRONTEND_URL ||
    (typeof window !== "undefined" ? window.location.origin : "");
  const bioLink = `${frontendUrl}/card/${card.shareUuid}`;
  const [copyStatus, setCopyStatus] = useState<"idle" | "success" | "error">(
    "idle"
  );

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(bioLink);
      setCopyStatus("success");

      // Tự ẩn thông báo sau 2s
      setTimeout(() => setCopyStatus("idle"), 2000);
    } catch (err) {
      setCopyStatus("error");
      setTimeout(() => setCopyStatus("idle"), 2000);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
      <div className="relative w-full max-w-2xl rounded-2xl bg-white p-8 shadow-2xl">
        {/* Close */}
        <button
          onClick={onClose}
          className="absolute right-4 top-4 rounded-full p-2 text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700"
          aria-label="Đóng"
        >
          <svg
            className="h-5 w-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>

        {/* Header */}
        <div className="mb-8 text-center">
          <h2 className="mb-2 text-2xl font-bold text-gray-900">
            Chia sẻ thẻ của bạn
          </h2>
          <p className="text-sm text-gray-600">
            Quét mã QR để xem trang bio của bạn
          </p>
        </div>

        {/* QR Code Section */}
        <div className="mb-8 flex justify-center">
          <div className="relative rounded-2xl bg-gradient-to-br from-gray-50 to-gray-100 p-6 shadow-lg">
            <div className="flex h-[240px] w-[240px] items-center justify-center rounded-xl bg-white p-4 shadow-inner">
              {card.qrCodeUrl ? (
                <img
                  src={card.qrCodeUrl}
                  alt="QR Code danh thiếp"
                  className="h-full w-full object-contain"
                />
              ) : (
                <div className="flex flex-col items-center justify-center text-gray-400">
                  <svg
                    className="mb-2 h-16 w-16"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2.01M19 8h2.01M12 19h.01M12 5h.01M5 12h.01M19 12h.01"
                    />
                  </svg>
                  <p className="text-sm">QR Code đang được tạo...</p>
                </div>
              )}
            </div>
          </div>
        </div>

        <hr className="my-6 border-gray-200" />

        {/* Link Section */}
        <div>
          <p className="mb-3 text-sm font-semibold text-gray-700">
            Đường dẫn đến bio của bạn
          </p>

          <div className="flex items-center gap-3">
            <div className="relative flex-1">
              <input
                value={bioLink}
                readOnly
                className="w-full rounded-lg border border-gray-300 bg-gray-50 px-4 py-3 pr-12 text-sm text-gray-700 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20"
              />
              <button
                onClick={handleCopy}
                className="absolute right-2 top-1/2 -translate-y-1/2 rounded-md p-2 text-gray-500 transition-colors hover:bg-gray-200 hover:text-gray-700"
                aria-label="Sao chép link"
              >
                {copyStatus === "success" ? (
                  <svg
                    className="h-5 w-5 text-green-600"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M5 13l4 4L19 7"
                    />
                  </svg>
                ) : (
                  <svg
                    className="h-5 w-5"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                    />
                  </svg>
                )}
              </button>
            </div>
            <button
              onClick={handleCopy}
              className="flex items-center gap-2 rounded-lg bg-blue-600 px-4 py-3 text-sm font-medium text-white transition-colors hover:bg-blue-700 active:bg-blue-800"
            >
              {copyStatus === "success" ? (
                <>
                  <svg
                    className="h-4 w-4"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M5 13l4 4L19 7"
                    />
                  </svg>
                  Đã sao chép
                </>
              ) : (
                <>
                  <Image
                    src="/assets/web/copy-left.png"
                    alt="Copy link"
                    width={16}
                    height={16}
                    className="shrink-0"
                  />
                  Sao chép link
                </>
              )}
            </button>
          </div>

          {/* Thông báo */}
          {copyStatus === "success" && (
            <p className="mt-3 flex items-center gap-2 text-sm text-green-600">
              <svg
                className="h-4 w-4"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M5 13l4 4L19 7"
                />
              </svg>
              Đã sao chép link thẻ thành công!
            </p>
          )}
          {copyStatus === "error" && (
            <p className="mt-3 flex items-center gap-2 text-sm text-red-600">
              <svg
                className="h-4 w-4"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
              Không thể sao chép link. Vui lòng thử lại.
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
