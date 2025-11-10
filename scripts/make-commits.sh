#!/usr/bin/env bash
# Helper script to make incremental meaningful commits
# Run from frontend-repo root

set -e

echo "🚀 Making incremental commits for frontend..."

# Ensure we're in the right directory
cd "$(dirname "$0")/.."

# Check if there are changes to commit
if git diff --quiet && git diff --cached --quiet; then
  echo "⚠️  No changes to commit"
  exit 0
fi

# Stage all changes
git add -A

# Commit 1: Enhanced loader animation
if git diff --cached --name-only | grep -q "src/App.vue"; then
  git add src/App.vue
  git commit -m "feat: Add enhanced loader animation with spinning rings and pulse effects" || true
  echo "✅ Commit 1: Enhanced loader"
fi

# Commit 2: Add lesson images from backend
if git diff --cached --name-only | grep -q "src/components/LessonCard.vue"; then
  git add src/components/LessonCard.vue
  git commit -m "feat: Display lesson images from backend with icon overlay and hover effects" || true
  echo "✅ Commit 2: Lesson images"
fi

# Commit 3: Environment configuration
if git diff --cached --name-only | grep -q ".env"; then
  git add .env.development .env.production
  git commit -m "config: Add environment-specific API base URLs for dev and production" || true
  echo "✅ Commit 3: Environment config"
fi

# Commit 4: Update config to use Vite env
if git diff --cached --name-only | grep -q "src/config.js"; then
  git add src/config.js
  git commit -m "refactor: Use Vite environment variables for API configuration" || true
  echo "✅ Commit 4: Config refactor"
fi

# Commit any remaining changes
if ! git diff --cached --quiet; then
  git commit -m "chore: Additional frontend improvements and polish"
  echo "✅ Commit 5: Additional improvements"
fi

echo ""
echo "📊 Summary:"
echo "📦 Total commits in this branch: $(git rev-list --count HEAD)"
echo "✨ Latest commits:"
git log --oneline -5

echo ""
echo "🎉 All commits created successfully!"
