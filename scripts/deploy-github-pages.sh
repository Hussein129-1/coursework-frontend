#!/usr/bin/env bash
# GitHub Pages Deployment Script
# This script builds the frontend and deploys to GitHub Pages

set -e

echo "🚀 Starting GitHub Pages deployment..."

# Colors for output
GREEN='\033[0.32m'
BLUE='\033[0.34m'
YELLOW='\033[0.33m'
NC='\033[0m' # No Color

# Ensure we're in the project root
cd "$(dirname "$0")/.."

echo -e "${BLUE}📦 Step 1: Building production bundle...${NC}"
npm run build

if [ ! -d "dist" ]; then
  echo "❌ Build failed: dist directory not found"
  exit 1
fi

echo -e "${GREEN}✅ Build complete!${NC}"

echo -e "${BLUE}📂 Step 2: Preparing deployment files...${NC}"

# Create a backup of development files if they don't exist
if [ ! -d "dev-backup" ]; then
  echo "Creating dev-backup folder..."
  mkdir -p dev-backup
  cp -r src dev-backup/
  cp -r public dev-backup/
  cp index.html dev-backup/
  cp vite.config.js dev-backup/
  echo "✅ Development files backed up to dev-backup/"
fi

# Copy dist contents to root for GitHub Pages
echo "Copying dist/assets to root..."
rm -rf assets
cp -r dist/assets ./

echo "Copying dist/index.html to root..."
cp dist/index.html ./index.html

# Update index.html to reference correct asset paths
sed -i 's|/assets/|./assets/|g' index.html

echo -e "${GREEN}✅ Files prepared!${NC}"

echo -e "${BLUE}📝 Step 3: Committing changes...${NC}"

# Stage the deployment files
git add index.html assets/

# Check if there are changes to commit
if git diff --staged --quiet; then
  echo -e "${YELLOW}⚠️  No changes to deploy${NC}"
else
  git commit -m "deploy: Update GitHub Pages deployment [$(date +'%Y-%m-%d %H:%M')]"
  echo -e "${GREEN}✅ Changes committed!${NC}"
fi

echo -e "${BLUE}🌐 Step 4: Pushing to GitHub...${NC}"
git push origin main

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo "🎉 Your app should be live at:"
echo "https://hussein129-1.github.io/coursework-frontend/"
echo ""
echo "Note: It may take a few minutes for GitHub Pages to update"
