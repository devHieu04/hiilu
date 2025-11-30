#!/bin/bash

# Script to copy assets from web to iOS app
# Usage: ./copy-assets.sh

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
WEB_ASSETS_DIR="../../frontend/public/assets/web"
IOS_ASSETS_DIR="../Hiilu/Assets.xcassets"

echo -e "${BLUE}🚀 Starting asset copy process...${NC}"

# Check if web assets directory exists
if [ ! -d "$WEB_ASSETS_DIR" ]; then
    echo -e "${YELLOW}❌ Web assets directory not found: $WEB_ASSETS_DIR${NC}"
    exit 1
fi

# Create iOS assets directory if it doesn't exist
mkdir -p "$IOS_ASSETS_DIR"

# Asset pairs: image_name_in_code|source_file_name
ASSET_PAIRS=(
    "Group 4|Group 4.png"
    "Group 69|Group 69.png"
    "image3|image3.png"
    "image4|image4.png"
    "antenna|antenna.png"
    "link|link.png"
    "brand (2)|brand (2).png"
    "color-palette|color-palette.png"
    "user-profile-01|user-profile-01.png"
    "id-card|id-card.png"
    "chat|chat (3).png"
    "link-angled|link-angled.png"
    "personalized-support|personalized-support.png"
)

# Function to create Contents.json for an image set
create_contents_json() {
    local image_set_name=$1
    local filename=$2
    local contents_file="$IOS_ASSETS_DIR/$image_set_name.imageset/Contents.json"

    cat > "$contents_file" << EOF
{
  "images" : [
    {
      "filename" : "$filename",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
}

# Copy each asset
copied_count=0
skipped_count=0

for pair in "${ASSET_PAIRS[@]}"; do
    IFS='|' read -r image_name source_file <<< "$pair"
    source_path="$WEB_ASSETS_DIR/$source_file"
    image_set_dir="$IOS_ASSETS_DIR/$image_name.imageset"

    if [ ! -f "$source_path" ]; then
        echo -e "${YELLOW}⚠️  Source file not found: $source_file (skipping)${NC}"
        skipped_count=$((skipped_count + 1))
        continue
    fi

    # Create image set directory
    mkdir -p "$image_set_dir"

    # Copy the image file
    cp "$source_path" "$image_set_dir/"

    # Create Contents.json
    create_contents_json "$image_name" "$source_file"

    echo -e "${GREEN}✓${NC} Copied: $source_file -> $image_name.imageset"
    copied_count=$((copied_count + 1))
done

echo ""
echo -e "${GREEN}✅ Done!${NC}"
echo -e "   Copied: ${GREEN}$copied_count${NC} assets"
if [ $skipped_count -gt 0 ]; then
    echo -e "   Skipped: ${YELLOW}$skipped_count${NC} assets (not found)"
fi
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo "   1. Open Xcode project"
echo "   2. Right-click on Assets.xcassets in Project Navigator"
echo "   3. Select 'Add Files to Hiilu...'"
echo "   4. Navigate to Hiilu/Assets.xcassets and select all .imageset folders"
echo "   5. Make sure 'Create groups' is selected and click 'Add'"
echo ""
echo -e "${YELLOW}💡 Tip: You can also drag & drop the .imageset folders directly into Assets.xcassets in Xcode${NC}"
