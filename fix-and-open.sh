#!/bin/bash

echo "🔧 Cleaning and opening NFL Predictions App..."
echo ""

# Clean derived data
echo "1. Cleaning derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/EndZone* 2>/dev/null
echo "   ✓ Done"
echo ""

# Verify structure
echo "2. Verifying project structure..."
PROJECT_DIR="/Users/ac09540/Desktop/Sports/NFLPredictionsApp/EndZone Oracle"

if [ ! -d "$PROJECT_DIR/NFLPredictions/Assets.xcassets" ]; then
    echo "   ✗ ERROR: Assets.xcassets not found!"
    exit 1
fi

if [ ! -d "$PROJECT_DIR/NFLPredictions/Preview Content" ]; then
    echo "   ✗ ERROR: Preview Content not found!"
    exit 1
fi

echo "   ✓ All folders present"
echo ""

# Open Xcode
echo "3. Opening Xcode..."
open "$PROJECT_DIR/EndZone Oracle.xcodeproj"
echo "   ✓ Project opened"
echo ""

echo "=========================================="
echo "✅ Ready to build!"
echo "=========================================="
echo ""
echo "In Xcode:"
echo "  1. Wait for Xcode to finish indexing"
echo "  2. Press Cmd+Shift+K (Clean Build Folder)"
echo "  3. Press Cmd+B (Build)"
echo "  4. Press Cmd+R (Run)"
echo ""
echo "The build should now succeed!"
echo ""
