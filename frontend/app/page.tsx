import { Navbar } from '@/components/layout/Navbar';
import { AboutSection } from '@/components/sections/AboutSection';
import { ContactSection } from '@/components/sections/ContactSection';
import { FaqSection } from '@/components/sections/FaqSection';
import { FeaturesSection } from '@/components/sections/FeaturesSection';
import { GuideSection } from '@/components/sections/GuideSection';
import { HeroSection } from '@/components/sections/HeroSection';
import { HighlightFeatures } from '@/components/sections/HighlightFeatures';

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center bg-[radial-gradient(circle_at_top,_#f6f4ff,_#eef4ff_60%,_#ffffff)] text-gray-900">
      <div className="w-full bg-gradient-to-r from-[#fef5ff] via-[#f1e8ff] to-[#e5f2ff]">
        <Navbar />
        <HeroSection />
      </div>
      <div className="w-full bg-white">
        <HighlightFeatures />
        <AboutSection />
      </div>
      <FeaturesSection />
      <GuideSection />
      <FaqSection />
      <ContactSection />
    </main>
  );
}
