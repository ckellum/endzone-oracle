#!/bin/bash

echo "🧹 NFL Predictions App - Clean & Build Script"
echo "=============================================="
echo ""

PROJECT_DIR="/Users/ac09540/Desktop/Sports/NFLPredictionsApp/EndZone Oracle"
PROJECT_NAME="EndZone Oracle"

cd "$PROJECT_DIR"

echo "Step 1: Removing derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/EndZone_Oracle-* 2>/dev/null
rm -rf ~/Library/Developer/Xcode/DerivedData/EndZone* 2>/dev/null
echo "   ✓ Derived data cleaned"
echo ""

echo "Step 2: Cleaning build folder..."
rm -rf build/ 2>/dev/null
echo "   ✓ Build folder cleaned"
echo ""

echo "Step 3: Verifying project structure..."
if [ ! -f "EndZone Oracle.xcodeproj/project.pbxproj" ]; then
    echo "   ✗ ERROR: Project file not found!"
    exit 1
fi

if [ ! -d "NFLPredictions/Assets.xcassets" ]; then
    echo "   ✗ ERROR: Assets.xcassets not found!"
    exit 1
fi

echo "   ✓ Project structure verified"
echo ""

echo "Step 4: Checking Xcode..."
if ! command -v xcodebuild &> /dev/null; then
    echo "   ⚠ xcodebuild not available (Command Line Tools active)"
    echo "   ℹ You'll need to build using Xcode IDE"
    echo ""
    echo "Opening project in Xcode..."
    open "$PROJECT_DIR/EndZone Oracle.xcodeproj"
    echo ""
    echo "In Xcode:"
    echo "  1. Press Cmd+Shift+K (Clean Build Folder)"
    echo "  2. Press Cmd+B (Build)"
    echo "  3. Press Cmd+R (Run)"
    exit 0
fi

echo "   ✓ xcodebuild available"
echo ""

echo "Step 5: Building project..."
echo "   (This may take a minute...)"
echo ""

# Try to build
xcodebuild \
    -project "EndZone Oracle.xcodeproj" \
    -scheme "EndZone Oracle" \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest' \
    clean build 2>&1 | tee /tmp/build-log.txt

BUILD_RESULT=${PIPESTATUS[0]}

echo ""
echo "=============================================="

if [ $BUILD_RESULT -eq 0 ]; then
    echo "✅ BUILD SUCCESSFUL!"
    echo ""
    echo "To run the app:"
    echo "  1. Open Xcode: open \"$PROJECT_DIR/EndZone Oracle.xcodeproj\""
    echo "  2. Press Cmd+R to run"
else
    echo "❌ BUILD FAILED"
    echo ""
    echo "Check the errors above or open in Xcode for details:"
    echo "  open \"$PROJECT_DIR/EndZone Oracle.xcodeproj\""
    echo ""
    echo "Full build log saved to: /tmp/build-log.txt"
    echo ""
    echo "Common fixes:"
    echo "  • Check Issue Navigator in Xcode (Cmd+5)"
    echo "  • Verify Team is selected in Signing & Capabilities"
    echo "  • Clean Build Folder (Cmd+Shift+K) and rebuild"
fi

echo "=============================================="
