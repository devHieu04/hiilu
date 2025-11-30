#!/bin/bash

# Alternative script that directly modifies Xcode project structure
# This script copies assets and creates proper Xcode asset catalog structure

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

WEB_ASSETS_DIR="../../frontend/public/assets/web"
IOS_ASSETS_DIR="../Hiilu/Assets.xcassets"

echo -e "${BLUE}🚀 Setting up iOS assets...${NC}"

# Check if web assets exist
if [ ! -d "$WEB_ASSETS_DIR" ]; then
    echo -e "${YELLOW}❌ Web assets not found at: $WEB_ASSETS_DIR${NC}"
    echo "Please run this script from Hiilu/scripts/ directory"
    exit 1
fi

# Create assets directory
mkdir -p "$IOS_ASSETS_DIR"

# Asset pairs: image_name|source_file
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

# Function to create image set
create_image_set() {
    local name=$1
    local source_file=$2
    local imageset_dir="$IOS_ASSETS_DIR/$name.imageset"

    mkdir -p "$imageset_dir"

    # Copy image
    if [ -f "$WEB_ASSETS_DIR/$source_file" ]; then
        cp "$WEB_ASSETS_DIR/$source_file" "$imageset_dir/"

        # Create Contents.json
        cat > "$imageset_dir/Contents.json" << EOF
{
  "images" : [
    {
      "filename" : "$source_file",
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
        echo -e "${GREEN}✓${NC} Created: $name.imageset"
        return 0
    else
        echo -e "${YELLOW}⚠️  Missing: $source_file${NC}"
        return 1
    fi
}

# Process all assets
success=0
failed=0

for pair in "${ASSET_PAIRS[@]}"; do
    IFS='|' read -r name source_file <<< "$pair"
    if create_image_set "$name" "$source_file"; then
        success=$((success + 1))
    else
        failed=$((failed + 1))
    fi
done

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo -e "   Success: ${GREEN}$success${NC}"
echo -e "   Failed: ${YELLOW}$failed${NC}"
echo ""
echo -e "${BLUE}📝 To add to Xcode:${NC}"
echo "   Option 1: Drag all .imageset folders from Finder into Assets.xcassets in Xcode"
echo "   Option 2: Use 'Add Files to Hiilu...' in Xcode and select the .imageset folders"
