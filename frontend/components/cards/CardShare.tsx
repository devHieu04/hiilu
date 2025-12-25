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
'use client';

import { useState } from 'react';
import Image from 'next/image';

interface ShareCardModalProps {
  card: any;
  onClose: () => void;
}

export default function CardShare({ card, onClose }: ShareCardModalProps) {
  const bioLink = `${process.env.NEXT_PUBLIC_FRONTEND_URL}/card/${card.shareUuid}`;
  const [copyStatus, setCopyStatus] = useState<'idle' | 'success' | 'error'>(
    'idle'
  );

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(bioLink);
      setCopyStatus('success');

      // Tự ẩn thông báo sau 2s
      setTimeout(() => setCopyStatus('idle'), 2000);
    } catch (err) {
      setCopyStatus('error');
      setTimeout(() => setCopyStatus('idle'), 2000);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
      <div className="relative w-[600px] rounded-xl bg-white p-6">
        {/* Close */}
        <button
          onClick={onClose}
          className="absolute right-4 top-4 text-gray-500 hover:text-gray-700"
        >
          ✕
        </button>

        {/* Header */}
        <div className="flex gap-6">
          <div className="flex-1">
            <h2 className="mb-2 text-xl font-semibold">
              Quét mã QR để xem trang bio của bạn
            </h2>
          </div>

          {/* QR */}
          <div className="flex h-[160px] w-[160px] items-center justify-center rounded-lg border">
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
          <p className="mb-2 font-medium">Đường dẫn đến bio của bạn</p>

          <div className="flex items-center gap-3">
            <input
              value={bioLink}
              readOnly
              className="flex-1 rounded-lg bg-gray-100 px-4 py-2 text-sm"
            />

            <button
              onClick={handleCopy}
              className="flex items-center gap-1 text-sm font-medium text-[#0055CC] hover:underline"
            >
              <Image
    src="/assets/web/copy-left.png"
    alt="Copy link"
    width={16}
    height={16}
    className="shrink-0"
  />
              Sao chép link
            </button>
          </div>

          {/* Thông báo */}
          {copyStatus === 'success' && (
            <p className="mt-2 text-sm text-green-600">
              ✅ Đã sao chép link thẻ!
            </p>
          )}
          {copyStatus === 'error' && (
            <p className="mt-2 text-sm text-red-600">
              ❌ Không thể sao chép link. Vui lòng thử lại.
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
