# Files to Add to Xcode Project

## New Swift Files Created

You need to add these 4 new files to your Xcode project:

### 1. Models
```
EndZone Oracle/NFLPredictions/Models/KalshiModels.swift
```
**Add to:** Models group in Xcode

### 2. Services
```
EndZone Oracle/NFLPredictions/Services/KalshiService.swift
```
**Add to:** Services group in Xcode

### 3. ViewModels
```
EndZone Oracle/NFLPredictions/ViewModels/KalshiViewModel.swift
```
**Add to:** ViewModels group in Xcode

### 4. Views/Components
```
EndZone Oracle/NFLPredictions/Views/Components/KalshiOddsView.swift
```
**Add to:** Views/Components group in Xcode

## How to Add Files to Xcode

### Method 1: Drag and Drop (Recommended)
1. Open Xcode project
2. In Xcode's Project Navigator (left sidebar)
3. Right-click on the appropriate folder (Models, Services, etc.)
4. Select "Add Files to 'EndZone Oracle'..."
5. Navigate to the file location
6. Select the file
7. ✅ Check "Copy items if needed"
8. ✅ Check your target (EndZone Oracle)
9. Click "Add"

### Method 2: Use Terminal
```bash
# Navigate to project directory
cd "/Users/ac09540/Desktop/Sports/NFLPredictionsApp/EndZone Oracle"

# Open Xcode project
open "EndZone Oracle.xcodeproj"

# Then use Method 1 to add files via Xcode UI
```

## Verify Files Are Added

After adding files, verify:

1. **Project Navigator** shows all 4 files
2. Each file has the correct **Target Membership**:
   - Click file in Navigator
   - Check right sidebar → Target Membership
   - ✅ "EndZone Oracle" should be checked

3. **Build the project** (⌘+B)
   - Should compile without errors
   - All new files should be recognized

## Modified Files (Already in Xcode)

These files were updated and don't need to be added:
- ✅ `GameCardView.swift` - Updated
- ✅ `PredictionsListView.swift` - Updated
- ✅ `SettingsView.swift` - Updated
- ✅ `ContentView.swift` - Updated (from earlier fix)
- ✅ `NFLPredictionsApp.swift` - Updated (from earlier fix)

## Build Verification

After adding files, test the build:

```bash
# From terminal (if Xcode command-line tools installed)
cd "/Users/ac09540/Desktop/Sports/NFLPredictionsApp/EndZone Oracle"
xcodebuild -project "EndZone Oracle.xcodeproj" \
  -scheme "EndZone Oracle" \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  clean build
```

Or in Xcode:
1. Select target: EndZone Oracle
2. Select device: Any iOS Simulator
3. Press ⌘+B (Build)
4. Press ⌘+R (Run) to test

## Quick Checklist

- [ ] Add `KalshiModels.swift` to Models group
- [ ] Add `KalshiService.swift` to Services group
- [ ] Add `KalshiViewModel.swift` to ViewModels group
- [ ] Add `KalshiOddsView.swift` to Views/Components group
- [ ] Verify Target Membership for all files
- [ ] Build project (⌘+B) - should succeed
- [ ] Run app (⌘+R) - should launch
- [ ] Go to Settings → Enable Kalshi Odds
- [ ] Enter API key
- [ ] View Predictions - should see odds (if markets exist)

## Troubleshooting

### "File not found" errors during build
- Check Target Membership for each file
- Ensure files are in correct folders
- Clean build folder (⌘+Shift+K) and rebuild

### Import errors ("Cannot find 'KalshiService' in scope")
- Verify all 4 files are added to project
- Check Target Membership
- Clean and rebuild

### Runtime crashes
- Check that API key is valid
- Ensure internet connection
- Check Xcode console for specific errors

---

**Next Step:** Open Xcode and add these 4 files to your project, then build and test!

