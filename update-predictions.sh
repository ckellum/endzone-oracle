#!/bin/bash

# Update Predictions Script
# This script updates the predictions.json file with new weekly predictions
# Run this each week when you have new prediction data

set -e  # Exit on error

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PREDICTIONS_FILE="$SCRIPT_DIR/EndZone Oracle/NFLPredictions/predictions.json"
ARCHIVE_DIR="$SCRIPT_DIR/predictions_archive"

echo "🏈 EndZone Oracle - Weekly Predictions Update"
echo "=============================================="
echo ""

# Check if new predictions file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: ./update-predictions.sh <path-to-new-predictions.json>"
    echo ""
    echo "Example:"
    echo "  ./update-predictions.sh ~/Downloads/enhanced_predictions_20251023.json"
    echo ""
    echo "This script will:"
    echo "  1. Archive the current predictions.json"
    echo "  2. Replace it with your new predictions"
    echo "  3. Commit and push to GitHub"
    echo ""
    exit 1
fi

NEW_PREDICTIONS="$1"

# Verify new predictions file exists
if [ ! -f "$NEW_PREDICTIONS" ]; then
    echo "❌ Error: File not found: $NEW_PREDICTIONS"
    exit 1
fi

# Verify it's valid JSON
if ! python3 -m json.tool "$NEW_PREDICTIONS" > /dev/null 2>&1; then
    echo "❌ Error: Invalid JSON file"
    exit 1
fi

echo "✅ New predictions file validated"
echo ""

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Archive current predictions.json with timestamp
if [ -f "$PREDICTIONS_FILE" ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    ARCHIVE_FILE="$ARCHIVE_DIR/predictions_$TIMESTAMP.json"
    cp "$PREDICTIONS_FILE" "$ARCHIVE_FILE"
    echo "📦 Archived current predictions to: predictions_archive/predictions_$TIMESTAMP.json"
fi

# Copy new predictions to predictions.json
cp "$NEW_PREDICTIONS" "$PREDICTIONS_FILE"
echo "✅ Updated predictions.json with new data"
echo ""

# Extract some stats from the new file
TOTAL_GAMES=$(python3 -c "import json; data=json.load(open('$PREDICTIONS_FILE')); print(len(data['predictions']))" 2>/dev/null || echo "unknown")
GENERATED_AT=$(python3 -c "import json; data=json.load(open('$PREDICTIONS_FILE')); print(data.get('generated_at', 'unknown'))" 2>/dev/null || echo "unknown")

echo "📊 New Predictions Summary:"
echo "   - Total Games: $TOTAL_GAMES"
echo "   - Generated: $GENERATED_AT"
echo ""

# Git operations
echo "🔄 Committing to Git..."
cd "$SCRIPT_DIR"

# Stage the predictions file
git add "$PREDICTIONS_FILE"

# Create commit message
COMMIT_MSG="Update weekly predictions - $(date +%Y-%m-%d)

- Updated predictions.json with $TOTAL_GAMES games
- Generated: $GENERATED_AT
- Archived previous predictions"

git commit -m "$COMMIT_MSG"
echo "✅ Committed changes"
echo ""

# Push to GitHub
echo "⬆️  Pushing to GitHub..."
git push
echo "✅ Successfully pushed to GitHub"
echo ""

echo "🎉 Predictions update complete!"
echo ""
echo "Next steps:"
echo "  1. Open Xcode and rebuild the app"
echo "  2. Test in simulator to verify new predictions load"
echo "  3. The app will now show the updated games"
echo ""
