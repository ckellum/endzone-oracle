#!/bin/bash

echo "🔍 NFL Predictions App - Build Diagnostics"
echo "=========================================="
echo ""

PROJECT_DIR="/Users/ac09540/Desktop/Sports/NFLPredictionsApp/EndZone Oracle"
cd "$PROJECT_DIR"

echo "1. Checking project structure..."
echo "   ✓ Project file exists: $([ -f "EndZone Oracle.xcodeproj/project.pbxproj" ] && echo "YES" || echo "NO")"
echo "   ✓ Assets.xcassets exists: $([ -d "NFLPredictions/Assets.xcassets" ] && echo "YES" || echo "NO")"
echo "   ✓ Info.plist exists: $([ -f "NFLPredictions/Info.plist" ] && echo "YES" || echo "NO")"
echo "   ✓ Core Data model exists: $([ -d "NFLPredictions/NFLPredictions.xcdatamodeld" ] && echo "YES" || echo "NO")"
echo ""

echo "2. Counting source files..."
SWIFT_COUNT=$(find NFLPredictions -name "*.swift" 2>/dev/null | wc -l | tr -d ' ')
echo "   ✓ Swift files: $SWIFT_COUNT"
echo ""

echo "3. Checking Assets structure..."
if [ -d "NFLPredictions/Assets.xcassets" ]; then
    echo "   ✓ Assets.xcassets location: NFLPredictions/Assets.xcassets"
    echo "   ✓ AppIcon exists: $([ -d "NFLPredictions/Assets.xcassets/AppIcon.appiconset" ] && echo "YES" || echo "NO")"
    echo "   ✓ AccentColor exists: $([ -d "NFLPredictions/Assets.xcassets/AccentColor.colorset" ] && echo "YES" || echo "NO")"
else
    echo "   ✗ Assets.xcassets NOT FOUND!"
fi
echo ""

echo "4. Checking Xcode configuration..."
if command -v xcodebuild &> /dev/null; then
    echo "   ✓ xcodebuild available: YES"

    echo ""
    echo "5. Listing available schemes..."
    xcodebuild -project "EndZone Oracle.xcodeproj" -list 2>/dev/null | grep -A 10 "Schemes:"

    echo ""
    echo "6. Checking build settings..."
    xcodebuild -project "EndZone Oracle.xcodeproj" -scheme "EndZone Oracle" -showBuildSettings 2>/dev/null | grep -E "(IPHONEOS_DEPLOYMENT_TARGET|INFOPLIST_FILE|GENERATE_INFOPLIST_FILE)" | head -3
else
    echo "   ✗ xcodebuild not available"
    echo "   NOTE: This is because Xcode Command Line Tools are active instead of full Xcode"
    echo "   This doesn't prevent building in Xcode IDE"
fi

echo ""
echo "=========================================="
echo "📋 Summary"
echo "=========================================="
echo ""
echo "To open the project in Xcode:"
echo "  open \"$PROJECT_DIR/EndZone Oracle.xcodeproj\""
echo ""
echo "In Xcode, try these steps:"
echo "  1. Product → Clean Build Folder (Cmd+Shift+K)"
echo "  2. Product → Build (Cmd+B)"
echo ""
echo "If build fails, look for:"
echo "  • Red error messages in the Issue Navigator (Cmd+5)"
echo "  • Specific file/line with the error"
echo "  • Error message text"
echo ""
echo "Common issues to check in Xcode:"
echo "  • File → Project Settings → Derived Data → Delete"
echo "  • Target membership (select a .swift file, check File Inspector)"
echo "  • Signing & Capabilities tab (Team selection)"
echo ""
