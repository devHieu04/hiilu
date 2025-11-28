'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/contexts/AuthContext';
import { DashboardLayout } from '@/components/dashboard/DashboardLayout';
import { CardPreview } from '@/components/cards/CardPreview';
import { cardsService, CreateCardRequest } from '@/lib/cards';

type TabType = 'intro' | 'links' | 'qr';

const themeColors = [
  { value: '', label: 'Không màu' },
  { value: '#0ea5e9', label: 'Xanh dương' },
  { value: '#8b5cf6', label: 'Tím' },
  { value: '#f472b6', label: 'Hồng' },
  { value: '#ef4444', label: 'Đỏ' },
  { value: '#f97316', label: 'Cam' },
  { value: '#fbbf24', label: 'Vàng' },
  { value: '#34d399', label: 'Xanh lá' },
];

const themeIcons = [
  { value: '', label: 'Không icon' },
  { value: '#0ea5e9', label: 'Xanh dương' },
  { value: '#c084fc', label: 'Tím nhạt' },
  { value: '#f9a8d4', label: 'Hồng nhạt' },
  { value: '#fb923c', label: 'Cam nhạt' },
  { value: '#fde047', label: 'Vàng nhạt' },
  { value: '#86efac', label: 'Xanh lá nhạt' },
];

export default function CreateCardPage() {
  const { user, token, isLoading: authLoading } = useAuth();
  const router = useRouter();
  const [activeTab, setActiveTab] = useState<TabType>('intro');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');

  // Form state
  const [cardData, setCardData] = useState<Partial<CreateCardRequest>>({
    cardName: '',
    ownerName: '',
    email: '',
    phoneNumber: '',
    company: '',
    address: '',
    description: '',
    theme: {
      color: '#0ea5e9',
    },
    links: [],
  });

  const [newLink, setNewLink] = useState({ title: '', url: '', icon: '' });
  const [avatarFile, setAvatarFile] = useState<File | null>(null);
  const [coverImageFile, setCoverImageFile] = useState<File | null>(null);
  const [avatarPreview, setAvatarPreview] = useState<string>('');
  const [coverImagePreview, setCoverImagePreview] = useState<string>('');

  useEffect(() => {
    if (!authLoading && (!user || !token)) {
      router.push('/login');
    }
  }, [user, token, authLoading, router]);

  const updateField = (field: keyof CreateCardRequest, value: any) => {
    setCardData((prev) => ({ ...prev, [field]: value }));
  };

  const updateTheme = (field: 'color' | 'icon', value: string) => {
    setCardData((prev) => ({
      ...prev,
      theme: {
        ...prev.theme,
        [field]: value,
      },
    }));
  };

  const addLink = () => {
    if (!newLink.title || !newLink.url) return;
    if (!cardData.links) cardData.links = [];
    setCardData((prev) => ({
      ...prev,
      links: [...(prev.links || []), { ...newLink }],
    }));
    setNewLink({ title: '', url: '', icon: '' });
  };

  const removeLink = (index: number) => {
    setCardData((prev) => ({
      ...prev,
      links: prev.links?.filter((_, i) => i !== index) || [],
    }));
  };

  const handleAvatarChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file type
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    if (!allowedTypes.includes(file.type)) {
      setError('Chỉ chấp nhận file ảnh (jpg, jpeg, png, gif, webp)');
      return;
    }

    // Validate file size (2MB for avatar)
    if (file.size > 2 * 1024 * 1024) {
      setError('Kích thước file ảnh đại diện không được vượt quá 2MB');
      return;
    }

    setAvatarFile(file);
    setError('');

    // Create preview
    const reader = new FileReader();
    reader.onloadend = () => {
      setAvatarPreview(reader.result as string);
    };
    reader.readAsDataURL(file);
  };

  const handleCoverImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file type
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
    if (!allowedTypes.includes(file.type)) {
      setError('Chỉ chấp nhận file ảnh (jpg, jpeg, png, gif, webp)');
      return;
    }

    // Validate file size (5MB for cover)
    if (file.size > 5 * 1024 * 1024) {
      setError('Kích thước file ảnh bìa không được vượt quá 5MB');
      return;
    }

    setCoverImageFile(file);
    setError('');

    // Create preview
    const reader = new FileReader();
    reader.onloadend = () => {
      setCoverImagePreview(reader.result as string);
    };
    reader.readAsDataURL(file);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!token) return;

    if (!cardData.cardName || !cardData.ownerName) {
      setError('Vui lòng nhập tên thẻ và tên chủ thẻ');
      return;
    }

    setIsSubmitting(true);
    setError('');

    try {
      // Prepare data - ensure theme and links are properly formatted
      const submitData: CreateCardRequest = {
        cardName: cardData.cardName!,
        ownerName: cardData.ownerName!,
        email: cardData.email || undefined,
        phoneNumber: cardData.phoneNumber || undefined,
        company: cardData.company || undefined,
        address: cardData.address || undefined,
        description: cardData.description || undefined,
        theme: cardData.theme && (cardData.theme.color || cardData.theme.icon)
          ? {
              color: cardData.theme.color || undefined,
              icon: cardData.theme.icon || undefined,
            }
          : undefined,
        links: cardData.links && cardData.links.length > 0
          ? cardData.links.filter((link) => link.title && link.url)
          : undefined,
      };

      await cardsService.createCard(
        submitData,
        token,
        avatarFile || undefined,
        coverImageFile || undefined
      );
      router.push('/dashboard');
    } catch (err: any) {
      setError(err.message || 'Không thể tạo thẻ. Vui lòng thử lại.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleCancel = () => {
    router.push('/dashboard');
  };

  if (authLoading) {
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
      <div className="flex gap-8">
        {/* Left: Settings Form */}
        <div className="flex-1 space-y-6">
          <div className="flex items-center gap-4">
            <button
              onClick={handleCancel}
              className="flex h-10 w-10 items-center justify-center rounded-full bg-[#455A6B] text-white transition-colors hover:bg-[#374a5a]"
            >
              <span className="material-icons">arrow_back</span>
            </button>
            <h1 className="text-2xl font-semibold text-gray-900">DANH THIẾP</h1>
          </div>

          {/* Tabs */}
          <div className="flex gap-2 border-b border-gray-200">
            <button
              onClick={() => setActiveTab('intro')}
              className={`flex items-center gap-2 border-b-2 px-4 py-3 text-sm font-medium transition-colors ${
                activeTab === 'intro'
                  ? 'border-[#0ea5e9] text-[#0ea5e9]'
                  : 'border-transparent text-gray-600 hover:text-gray-900'
              }`}
            >
              <span className="material-icons text-lg">person</span>
              Giới thiệu
            </button>
            <button
              onClick={() => setActiveTab('links')}
              className={`flex items-center gap-2 border-b-2 px-4 py-3 text-sm font-medium transition-colors ${
                activeTab === 'links'
                  ? 'border-[#0ea5e9] text-[#0ea5e9]'
                  : 'border-transparent text-gray-600 hover:text-gray-900'
              }`}
            >
              <span className="material-icons text-lg">link</span>
              Link
            </button>
            <button
              onClick={() => setActiveTab('qr')}
              className={`flex items-center gap-2 border-b-2 px-4 py-3 text-sm font-medium transition-colors ${
                activeTab === 'qr'
                  ? 'border-[#0ea5e9] text-[#0ea5e9]'
                  : 'border-transparent text-gray-600 hover:text-gray-900'
              }`}
            >
              <span className="material-icons text-lg">qr_code</span>
              Mã QR
            </button>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Tab Content: Introduction */}
            {activeTab === 'intro' && (
              <div className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Tên thẻ
                  </label>
                  <input
                    type="text"
                    value={cardData.cardName}
                    onChange={(e) => updateField('cardName', e.target.value)}
                    placeholder="Tên thẻ"
                    required
                    className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                  />
                </div>

                {/* Theme Selection */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-3">
                    Chủ đề
                  </label>
                  <div className="space-y-4">
                    <div>
                      <p className="mb-2 text-xs text-gray-500">Màu sắc</p>
                      <div className="flex flex-wrap gap-3">
                        {themeColors.map((color) => (
                          <button
                            key={color.value}
                            type="button"
                            onClick={() => updateTheme('color', color.value)}
                            className={`h-10 w-10 rounded-full border-2 transition-all ${
                              cardData.theme?.color === color.value
                                ? 'border-[#8b5cf6] scale-110'
                                : 'border-gray-300'
                            }`}
                            style={{
                              backgroundColor: color.value || 'transparent',
                              backgroundImage: color.value
                                ? 'none'
                                : 'linear-gradient(45deg, #ccc 25%, transparent 25%), linear-gradient(-45deg, #ccc 25%, transparent 25%), linear-gradient(45deg, transparent 75%, #ccc 75%), linear-gradient(-45deg, transparent 75%, #ccc 75%)',
                              backgroundSize: '8px 8px',
                              backgroundPosition: '0 0, 0 4px, 4px -4px, -4px 0px',
                            }}
                            title={color.label}
                          >
                            {!color.value && (
                              <span className="material-icons text-gray-400 text-lg">close</span>
                            )}
                          </button>
                        ))}
                      </div>
                    </div>
                    <div>
                      <p className="mb-2 text-xs text-gray-500">Icon</p>
                      <div className="flex flex-wrap gap-3">
                        {themeIcons.map((icon) => (
                          <button
                            key={icon.value}
                            type="button"
                            onClick={() => updateTheme('icon', icon.value)}
                            className={`h-10 w-10 rounded-full border-2 transition-all ${
                              cardData.theme?.icon === icon.value
                                ? 'border-[#8b5cf6] scale-110'
                                : 'border-gray-300'
                            }`}
                            style={{
                              backgroundColor: icon.value || 'transparent',
                              backgroundImage: icon.value
                                ? 'none'
                                : 'linear-gradient(45deg, #ccc 25%, transparent 25%), linear-gradient(-45deg, #ccc 25%, transparent 25%), linear-gradient(45deg, transparent 75%, #ccc 75%), linear-gradient(-45deg, transparent 75%, #ccc 75%)',
                              backgroundSize: '8px 8px',
                              backgroundPosition: '0 0, 0 4px, 4px -4px, -4px 0px',
                            }}
                            title={icon.label}
                          >
                            {!icon.value && (
                              <span className="material-icons text-gray-400 text-lg">close</span>
                            )}
                          </button>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>

                {/* Avatar Upload */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Ảnh đại diện
                  </label>
                  <div className="flex items-center gap-4">
                    <div className="h-20 w-20 rounded-full border-2 border-dashed border-gray-300 bg-gray-50 flex items-center justify-center overflow-hidden">
                      {avatarPreview ? (
                        <img
                          src={avatarPreview}
                          alt="Avatar preview"
                          className="h-full w-full object-cover"
                        />
                      ) : (
                        <span className="material-icons text-gray-400">person</span>
                      )}
                    </div>
                    <div className="flex-1">
                      <input
                        type="file"
                        accept="image/jpeg,image/jpg,image/png,image/gif,image/webp"
                        onChange={handleAvatarChange}
                        className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-2 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none file:mr-4 file:py-1 file:px-3 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-[#455A6B] file:text-white hover:file:bg-[#374a5a]"
                      />
                      <p className="mt-1 text-xs text-gray-500">
                        JPG, PNG, GIF, WEBP (tối đa 2MB, khuyến nghị 400x400px)
                      </p>
                    </div>
                  </div>
                </div>

                {/* Cover Image Upload */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Ảnh bìa
                  </label>
                  <div className="flex items-center gap-4">
                    <div className="h-20 w-32 rounded-lg border-2 border-dashed border-gray-300 bg-gray-50 flex items-center justify-center overflow-hidden">
                      {coverImagePreview ? (
                        <img
                          src={coverImagePreview}
                          alt="Cover preview"
                          className="h-full w-full object-cover"
                        />
                      ) : (
                        <span className="material-icons text-gray-400">image</span>
                      )}
                    </div>
                    <div className="flex-1">
                      <input
                        type="file"
                        accept="image/jpeg,image/jpg,image/png,image/gif,image/webp"
                        onChange={handleCoverImageChange}
                        className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-2 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none file:mr-4 file:py-1 file:px-3 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-[#455A6B] file:text-white hover:file:bg-[#374a5a]"
                      />
                      <p className="mt-1 text-xs text-gray-500">
                        JPG, PNG, GIF, WEBP (tối đa 5MB, khuyến nghị 1200x600px)
                      </p>
                    </div>
                  </div>
                </div>

                {/* Personal Info Fields */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Tên:</label>
                  <input
                    type="text"
                    value={cardData.ownerName}
                    onChange={(e) => updateField('ownerName', e.target.value)}
                    placeholder="Họ và tên"
                    required
                    className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Địa chỉ:
                  </label>
                  <input
                    type="text"
                    value={cardData.address || ''}
                    onChange={(e) => updateField('address', e.target.value)}
                    placeholder="Địa chỉ"
                    className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Email:</label>
                  <input
                    type="email"
                    value={cardData.email || ''}
                    onChange={(e) => updateField('email', e.target.value)}
                    placeholder="Email"
                    className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Số điện thoại:
                  </label>
                  <input
                    type="tel"
                    value={cardData.phoneNumber || ''}
                    onChange={(e) => updateField('phoneNumber', e.target.value)}
                    placeholder="Số điện thoại"
                    className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Công việc:
                  </label>
                  <input
                    type="text"
                    value={cardData.description || ''}
                    onChange={(e) => updateField('description', e.target.value)}
                    placeholder="Công việc"
                    className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Doanh nghiệp:
                  </label>
                  <input
                    type="text"
                    value={cardData.company || ''}
                    onChange={(e) => updateField('company', e.target.value)}
                    placeholder="Doanh nghiệp"
                    className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Mô tả:</label>
                  <textarea
                    value={cardData.description || ''}
                    onChange={(e) => updateField('description', e.target.value)}
                    placeholder="Mô tả"
                    rows={4}
                    className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                  />
                </div>
              </div>
            )}

            {/* Tab Content: Links */}
            {activeTab === 'links' && (
              <div className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Thêm link mới
                  </label>
                  <div className="space-y-3">
                    <input
                      type="text"
                      value={newLink.title}
                      onChange={(e) => setNewLink({ ...newLink, title: e.target.value })}
                      placeholder="Tiêu đề"
                      className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                    />
                    <input
                      type="url"
                      value={newLink.url}
                      onChange={(e) => setNewLink({ ...newLink, url: e.target.value })}
                      placeholder="URL"
                      className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                    />
                    <input
                      type="text"
                      value={newLink.icon}
                      onChange={(e) => setNewLink({ ...newLink, icon: e.target.value })}
                      placeholder="Icon (material-icons name)"
                      className="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm transition-colors focus:border-[#8b5cf6] focus:bg-white focus:outline-none"
                    />
                    <button
                      type="button"
                      onClick={addLink}
                      className="w-full rounded-xl bg-[#455A6B] px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-[#374a5a]"
                    >
                      Thêm link
                    </button>
                  </div>
                </div>

                {/* List of Links */}
                {cardData.links && cardData.links.length > 0 && (
                  <div className="space-y-3">
                    <label className="block text-sm font-medium text-gray-700">
                      Danh sách links
                    </label>
                    {cardData.links.map((link, index) => (
                      <div
                        key={index}
                        className="flex items-center justify-between rounded-lg border border-gray-200 bg-white p-4"
                      >
                        <div className="flex-1">
                          <p className="font-medium text-gray-900">{link.title}</p>
                          <p className="text-sm text-gray-500">{link.url}</p>
                        </div>
                        <button
                          type="button"
                          onClick={() => removeLink(index)}
                          className="ml-4 text-red-500 hover:text-red-700"
                        >
                          <span className="material-icons">delete</span>
                        </button>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}

            {/* Tab Content: QR Code */}
            {activeTab === 'qr' && (
              <div className="space-y-6">
                <div className="rounded-lg border border-gray-200 bg-gray-50 p-8 text-center">
                  <p className="text-sm text-gray-600">
                    Mã QR sẽ được tạo tự động sau khi bạn tạo thẻ
                  </p>
                </div>
              </div>
            )}

            {error && (
              <div className="rounded-lg bg-red-50 p-3 text-sm text-red-600">{error}</div>
            )}

            {/* Action Buttons */}
            <div className="flex justify-end gap-4 border-t border-gray-200 pt-6">
              <button
                type="button"
                onClick={handleCancel}
                className="rounded-lg border border-gray-300 bg-white px-6 py-3 text-sm font-medium text-gray-700 transition-colors hover:bg-gray-50"
              >
                Huỷ
              </button>
              <button
                type="submit"
                disabled={isSubmitting}
                className="rounded-lg bg-[#455A6B] px-6 py-3 text-sm font-semibold text-white transition-colors hover:bg-[#374a5a] disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isSubmitting ? 'Đang tạo...' : 'Xác nhận'}
              </button>
            </div>
          </form>
        </div>

        {/* Right: Preview */}
        <div className="hidden lg:block">
          <CardPreview
            cardData={cardData}
            avatarPreview={avatarPreview}
            coverImagePreview={coverImagePreview}
          />
        </div>
      </div>
    </DashboardLayout>
  );
}
