# NFL Predictions App - Setup Guide

This guide will help you get the iOS app up and running in Xcode.

## Quick Start (5 Minutes)

### Step 1: Create Xcode Project
1. Open Xcode
2. **File → New → Project**
3. Select **iOS** → **App**
4. Configure:
   - Product Name: `NFLPredictions`
   - Team: (your name)
   - Organization Identifier: `com.yourname` or use reverse domain
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **Core Data** ✅ (Important!)
   - Include Tests: Optional
5. Save in: `/Users/ac09540/Desktop/Sports/NFLPredictionsApp/`

### Step 2: Replace Generated Files

The Xcode template creates some default files. Replace them:

1. **Delete the default files** (keep the project structure):
   - `NFLPredictionsApp.swift` (we'll replace it)
   - `ContentView.swift` (we'll replace it)
   - `NFLPredictions.xcdatamodeld` (we'll replace it)

2. **Add all the source folders**:
   - In Xcode project navigator, right-click on "NFLPredictions" (the blue folder)
   - Select "Add Files to NFLPredictions..."
   - Navigate to the NFLPredictions folder you have
   - Select ALL folders: App, Models, Views, Services, ViewModels, Utilities
   - ✅ Check "Copy items if needed"
   - ✅ Check "Create groups"
   - Click "Add"

3. **Add the CoreData model**:
   - Add the `NFLPredictions.xcdatamodeld` folder the same way
   - Make sure it's included in target membership

### Step 3: Configure Target Settings

1. In Xcode, click on the project (blue icon) in the navigator
2. Select the "NFLPredictions" target
3. Go to "General" tab:
   - **Minimum Deployments**: iOS 17.0
   - **Supported Destinations**: iPhone, iPad (optional)

4. Go to "Build Settings" tab:
   - Search for "Swift Language Version"
   - Ensure it's set to "Swift 5" or later

### Step 4: Add Info.plist (if needed)

If the project didn't create Info.plist automatically:
1. Use the provided `Info.plist` file
2. In Xcode, select target → Info tab
3. Import or manually configure settings

### Step 5: Build and Run

1. Select a simulator (iPhone 15 Pro recommended) or device
2. Press **Cmd + B** to build
3. Fix any errors (see Troubleshooting below)
4. Press **Cmd + R** to run

## Detailed Setup

### Project Structure Verification

After adding files, your Xcode navigator should look like:

```
NFLPredictions
├── App
│   ├── NFLPredictionsApp.swift
│   └── ContentView.swift
├── Models
│   ├── PredictionData.swift
│   ├── Prediction.swift
│   └── GameResult.swift
├── ViewModels
│   ├── PredictionsViewModel.swift
│   ├── StatsViewModel.swift
│   └── ResultsViewModel.swift
├── Views
│   ├── Home
│   │   ├── PredictionsListView.swift
│   │   ├── GameCardView.swift
│   │   └── PredictionHeaderView.swift
│   ├── Detail
│   │   ├── GameDetailView.swift
│   │   └── ComparisonTableView.swift
│   ├── Stats
│   │   ├── StatsDashboardView.swift
│   │   ├── AccuracyCircleView.swift
│   │   ├── PerformanceChartView.swift
│   │   └── TeamStatsListView.swift
│   ├── Results
│   │   └── ResultsEntryView.swift
│   ├── Settings
│   │   └── SettingsView.swift
│   └── Components
│       ├── TeamHeaderView.swift
│       ├── PickBadge.swift
│       ├── StatCard.swift
│       └── AccuracyIndicator.swift
├── Services
│   ├── PersistenceController.swift
│   ├── PredictionService.swift
│   ├── DataPersistenceService.swift
│   └── AnalyticsService.swift
├── Utilities
│   ├── NFLTeams.swift
│   └── Extensions
│       ├── Color+Extensions.swift
│       └── Date+Extensions.swift
└── NFLPredictions.xcdatamodeld
    └── NFLPredictions.xcdatamodel
        └── contents
```

### Adding Team Helmet Images (Optional)

1. **Create Asset Catalog** (if not exists):
   - File → New → File
   - Resource → Asset Catalog
   - Name it "Assets"

2. **Add Images**:
   - Click on Assets.xcassets in navigator
   - Click "+" → "New Image Set"
   - Name it according to team (e.g., "steelers", "patriots", etc.)
   - Drag PNG images into 1x, 2x, 3x slots (or just use one)

3. **Image Requirements**:
   - Format: PNG with transparent background
   - Size: 512x512 recommended
   - Naming: Match `helmetAssetName` in NFLTeams.swift

**Where to get helmet images:**
- Official NFL website
- Team websites
- Or use the placeholder icons (app works without images)

### Configuring CoreData

The CoreData model should include one entity:

**GameResult Entity:**
- id (UUID)
- team1Name (String)
- team2Name (String)
- team1ActualScore (Integer 16)
- team2ActualScore (Integer 16)
- team1PredictedScore (Integer 16)
- team2PredictedScore (Integer 16)
- predictedWinner (String)
- gameDate (Date)
- timestamp (String)
- isCompleted (Boolean)

To verify:
1. Click on `NFLPredictions.xcdatamodeld` in Xcode
2. Check that the GameResult entity exists with all attributes
3. If not, add them manually or use the provided model file

## Testing the App

### Method 1: Use Sample Data
1. Run the app
2. On the home screen, tap "Load Sample Data"
3. Sample predictions will appear

### Method 2: Import Real JSON
1. Save your prediction JSON to Files app or iCloud Drive
2. Run the app
3. Tap the download icon in navigation bar
4. Select your JSON file

### Method 3: Transfer via AirDrop (Physical Device)
1. AirDrop your JSON file to iPhone/iPad
2. Open in Files app
3. Import from app

## Troubleshooting

### Build Errors

**Error: "Cannot find 'NFLTeam' in scope"**
- Solution: Ensure NFLTeams.swift is in the project
- Check target membership (click file → File Inspector → Target Membership)

**Error: "No such module 'Charts'"**
- Solution: Charts is built into iOS 17+
- Verify deployment target is iOS 17.0 or higher
- If using older iOS, comment out PerformanceChartView.swift

**Error: "Failed to load persistent stores"**
- Solution: CoreData model name mismatch
- In PersistenceController.swift, verify:
  ```swift
  container = NSPersistentContainer(name: "NFLPredictions")
  ```
- Should match your .xcdatamodeld file name

**Error: Multiple Info.plist files**
- Solution: Use only one Info.plist
- Delete extras or configure in Target → Info tab

### Runtime Errors

**App crashes on launch**
1. Check console for error message
2. Common causes:
   - CoreData model mismatch
   - Missing environment objects
   - SwiftUI preview code in production

**JSON import fails**
- Verify JSON format matches exactly
- Check team names are spelled correctly
- Ensure all required fields are present

**Images not showing**
- Check asset names match NFLTeams.swift
- Verify images are in Assets.xcassets
- Check target membership of Assets catalog

### Performance Issues

**Slow scrolling**
- This shouldn't happen with LazyVStack
- Try running on device instead of simulator
- Check for accidental infinite loops in computed properties

**Large JSON files**
- The app handles 50+ games easily
- If issues, consider pagination

## Advanced Configuration

### Custom Bundle Identifier
1. Target → General
2. Change "Bundle Identifier"
3. Format: `com.yourname.NFLPredictions`

### App Icon
1. Create 1024x1024 PNG icon
2. Assets.xcassets → AppIcon
3. Drag icon into "App Store iOS" slot
4. Xcode generates other sizes

### Display Name
Change what appears on home screen:
1. Info.plist
2. Change `CFBundleDisplayName`
3. Or set in Target → Info → "Bundle display name"

### Version Number
Target → General → Version (e.g., 1.0.1)

## Running on Physical Device

1. **Connect iPhone/iPad** to Mac via USB
2. **Select device** in Xcode toolbar
3. **Trust Mac on device** (first time)
4. **Sign with Apple ID**:
   - Target → Signing & Capabilities
   - Team → Add Account
   - Sign in with Apple ID (free)
5. **Build and Run** (Cmd + R)
6. **Trust Developer** on device:
   - Settings → General → VPN & Device Management
   - Trust your developer profile

## Next Steps

1. ✅ Get app running with sample data
2. ✅ Import your prediction JSON
3. ✅ Enter some game results
4. ✅ Check statistics dashboard
5. 🎨 Add team helmet images
6. 🎨 Customize colors/branding
7. 📱 Run on physical device
8. 🚀 Add your own features!

## Getting Help

### Check These First:
1. Console output (Cmd + Shift + Y in Xcode)
2. Breakpoint at error location
3. SwiftUI preview for individual views
4. Clean build folder (Cmd + Shift + K)

### Common Solutions:
- **Clean Build**: Cmd + Shift + K, then Cmd + B
- **Reset Simulator**: Device → Erase All Content and Settings
- **Restart Xcode**: Sometimes it's just Xcode being Xcode
- **Update Xcode**: Ensure you're on latest version

## Customization Ideas

### Easy Customizations:
- Change color scheme in Color+Extensions.swift
- Adjust confidence thresholds in Prediction.swift
- Modify team colors in NFLTeams.swift
- Change card corner radius in views

### Medium Difficulty:
- Add new statistics calculations
- Create custom chart types
- Add filtering by division/conference
- Implement search functionality

### Advanced:
- Add widgets
- Implement push notifications
- Create share sheet for predictions
- Add iCloud sync

---

**You're all set! 🎉**

If you encounter issues not covered here, check the code comments in each file for additional documentation.

Happy coding! 🏈


