"use client";

import { useState } from "react";
import Image from "next/image";
import { CreateCardRequest } from "@/lib/cards";

interface CardPreviewProps {
  cardData: Partial<CreateCardRequest>;
  avatarPreview?: string;
  coverImagePreview?: string;
}

// Helper function to detect link type and get icon
const getLinkIcon = (url: string, customIcon?: string): string => {
  if (customIcon) return customIcon;

  const lowerUrl = url.toLowerCase();
  if (lowerUrl.includes("github.com")) return "code";
  if (lowerUrl.includes("linkedin.com")) return "work";
  if (lowerUrl.includes("facebook.com") || lowerUrl.includes("fb.com"))
    return "facebook";
  if (lowerUrl.includes("zalo.me") || lowerUrl.includes("zalo")) return "chat";
  if (lowerUrl.includes("twitter.com") || lowerUrl.includes("x.com"))
    return "tag";
  if (lowerUrl.includes("instagram.com")) return "photo_camera";
  if (lowerUrl.includes("youtube.com")) return "play_circle";
  if (lowerUrl.includes("tiktok.com")) return "music_note";
  if (lowerUrl.includes("behance.net")) return "palette";
  if (lowerUrl.includes("dribbble.com")) return "sports_basketball";
  return "link";
};

export function CardPreview({
  cardData,
  avatarPreview,
  coverImagePreview
}: CardPreviewProps) {
  const [activeTab, setActiveTab] = useState<"intro" | "links">("intro");
  const themeColor = cardData.theme?.color || "#0ea5e9";
  const getInitials = (name?: string) => {
    if (!name) return "?";
    return name
      .split(" ")
      .map((n) => n[0])
      .join("")
      .toUpperCase()
      .slice(0, 2);
  };

  // Format phone number for tel: link (remove spaces, special chars except +)
  const formatPhoneForTel = (phone?: string): string => {
    if (!phone) return "";
    // Remove all spaces, dashes, parentheses, and keep only digits and +
    return phone.replace(/[\s\-\(\)]/g, "");
  };

  // Format email for mailto: link (ensure it's valid)
  const formatEmailForMailto = (email?: string): string => {
    if (!email) return "";
    // Remove any whitespace and ensure it's a valid email format
    return email.trim();
  };

  return (
    <div className="sticky top-8 flex justify-center">
      <div className="relative h-[600px] w-[320px] rounded-[40px] border-[12px] border-gray-800 bg-gray-900 shadow-2xl">
        {/* Phone notch */}
        <div className="absolute left-1/2 top-0 h-6 w-32 -translate-x-1/2 rounded-b-2xl bg-gray-900"></div>

        {/* Screen content */}
        <div className="flex h-full flex-col overflow-y-auto rounded-[28px] bg-white">
          {/* Top Background Section */}
          <div
            className="relative h-40 w-full"
            style={{
              backgroundColor:
                coverImagePreview || cardData.coverImageUrl
                  ? "transparent"
                  : cardData.theme?.color || "#fef3c7"
            }}
          >
            {coverImagePreview || cardData.coverImageUrl ? (
              <img
                src={coverImagePreview || cardData.coverImageUrl}
                alt="Cover"
                className="h-full w-full object-cover"
              />
            ) : null}

            {/* Avatar - overlapping */}
            <div className="absolute left-1/4 top-full -translate-x-1/4 -translate-y-1/2">
              {avatarPreview || cardData.avatarUrl ? (
                <div className="h-32 w-32 rounded-full border-4 border-white shadow-lg overflow-hidden">
                  <img
                    src={avatarPreview || cardData.avatarUrl}
                    alt={cardData.ownerName || "Avatar"}
                    className="h-full w-full object-cover"
                  />
                </div>
              ) : (
                <div
                  className="flex h-32 w-32 items-center justify-center rounded-full border-4 border-white text-4xl font-semibold text-white shadow-lg"
                  style={{ backgroundColor: themeColor }}
                >
                  {getInitials(cardData.ownerName)}
                </div>
              )}
            </div>
          </div>

          {/* Main Content */}
          <div className="flex flex-1 flex-col px-6 pt-16 pb-6">
            {/* Name */}
            <h2 className="mb-2 text-left text-xl font-semibold text-gray-900">
              {cardData.ownerName || "Tên của bạn"}
            </h2>

            {/* Description - thay thế vị trí công việc */}
            {cardData.description && (
              <p className="mb-4 text-left text-sm text-gray-600">
                {cardData.description}
              </p>
            )}

            {/* Tabs */}
            <div className="mb-4 flex w-full gap-2 border-b border-gray-200">
              <button
                onClick={() => setActiveTab("intro")}
                className="flex-1 border-b-2 pb-2 text-sm font-medium transition-colors border-transparent text-gray-500"
                style={
                  activeTab === "intro"
                    ? {
                        borderBottomColor: themeColor,
                        color: themeColor
                      }
                    : {}
                }
              >
                Giới thiệu
              </button>
              <button
                onClick={() => setActiveTab("links")}
                className="flex-1 border-b-2 pb-2 text-sm font-medium transition-colors border-transparent text-gray-500"
                style={
                  activeTab === "links"
                    ? {
                        borderBottomColor: themeColor,
                        color: themeColor
                      }
                    : {}
                }
              >
                Liên kết
              </button>
            </div>

            {activeTab === "intro" && (
              <div className="w-full space-y-2">
                {cardData.company && (
                  <div className="flex items-center gap-2 rounded-lg px-3 py-1.5">
                    <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-gradient-to-br from-orange-400 to-orange-500">
                      <span className="material-icons text-sm text-white">
                        business
                      </span>
                    </div>
                    <span className="flex-1 text-sm font-medium text-gray-900">
                      {cardData.company}
                    </span>
                  </div>
                )}

                {cardData.email && (
                  <a
                    href={`mailto:${formatEmailForMailto(cardData.email)}`}
                    className="flex items-center gap-2 rounded-lg px-3 py-1.5 transition-all hover:bg-gray-50"
                  >
                    <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-gradient-to-br from-blue-400 to-blue-500">
                      <span className="material-icons text-sm text-white">
                        email
                      </span>
                    </div>
                    <span className="flex-1 text-sm font-medium text-gray-900">
                      {cardData.email}
                    </span>
                  </a>
                )}

                {cardData.phoneNumber && (
                  <a
                    href={`tel:${formatPhoneForTel(cardData.phoneNumber)}`}
                    className="flex items-center gap-2 rounded-lg px-3 py-1.5 transition-all hover:bg-gray-50"
                  >
                    <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-gradient-to-br from-green-400 to-green-500">
                      <span className="material-icons text-sm text-white">
                        phone
                      </span>
                    </div>
                    <span className="flex-1 text-sm font-medium text-gray-900">
                      {cardData.phoneNumber}
                    </span>
                  </a>
                )}

                {/* Address */}
                {cardData.address && (
                  <div className="flex items-center gap-2 rounded-lg px-3 py-1.5">
                    <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-gradient-to-br from-purple-400 to-purple-500">
                      <span className="material-icons text-sm text-white">
                        location_on
                      </span>
                    </div>
                    <span className="flex-1 text-sm font-medium text-gray-900">
                      {cardData.address}
                    </span>
                  </div>
                )}
              </div>
            )}

            {/* Links Tab */}
            {activeTab === "links" && (
              <div className="w-full space-y-2">
                {cardData.links && cardData.links.length > 0 ? (
                  cardData.links.map((link, index) => {
                    const linkIcon = getLinkIcon(link.url, link.icon);
                    // Determine gradient color based on link type
                    const getLinkGradient = (url: string) => {
                      const lowerUrl = url.toLowerCase();
                      if (lowerUrl.includes("github.com"))
                        return "from-gray-600 to-gray-700";
                      if (lowerUrl.includes("linkedin.com"))
                        return "from-blue-500 to-blue-600";
                      if (
                        lowerUrl.includes("facebook.com") ||
                        lowerUrl.includes("fb.com")
                      )
                        return "from-blue-600 to-blue-700";
                      if (
                        lowerUrl.includes("zalo.me") ||
                        lowerUrl.includes("zalo")
                      )
                        return "from-blue-400 to-blue-500";
                      if (
                        lowerUrl.includes("twitter.com") ||
                        lowerUrl.includes("x.com")
                      )
                        return "from-sky-400 to-sky-500";
                      if (lowerUrl.includes("instagram.com"))
                        return "from-pink-500 to-pink-600";
                      if (lowerUrl.includes("youtube.com"))
                        return "from-red-500 to-red-600";
                      return "from-gray-400 to-gray-500";
                    };

                    return (
                      <a
                        key={index}
                        href={link.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="flex items-center gap-2 rounded-lg px-3 py-1.5 transition-all hover:bg-gray-50"
                      >
                        <div
                          className={`flex h-7 w-7 items-center justify-center rounded-lg bg-gradient-to-br ${getLinkGradient(
                            link.url
                          )}`}
                        >
                          <span className="material-icons text-sm text-white">
                            {linkIcon}
                          </span>
                        </div>
                        <span className="flex-1 text-sm font-medium text-gray-900">
                          {link.title}
                        </span>
                      </a>
                    );
                  })
                ) : (
                  <p className="text-center text-sm text-gray-500 py-4">
                    Chưa có liên kết nào
                  </p>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
