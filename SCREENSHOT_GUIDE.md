# Screenshot Generation Guide for EndZone Oracle

## Required Screenshots

You need to capture 5 screenshots for the App Store using the iOS Simulator.

## Setup Instructions

### 1. Open iOS Simulator

1. Open Xcode
2. Open your project: `EndZone Oracle/EndZone Oracle.xcodeproj`
3. Select device: **iPhone 15 Pro Max** from the device dropdown
4. Press **Cmd + R** to build and run the app

### 2. Configure Simulator

1. Once simulator opens, go to **Window → Physical Size** (or Cmd + 1)
2. This ensures screenshots are captured at the correct resolution

## Screenshot Checklist

### Screenshot 1: Home/Predictions Screen
**What to capture:** Main predictions list showing upcoming NFL games

**Steps:**
1. Launch the app (should open to predictions screen)
2. Ensure you can see 3-4 game cards with team logos
3. Make sure the header "EndZone Oracle" or app branding is visible
4. Press **Cmd + S** to save screenshot

**Filename:** `01_home_predictions.png`
**Shows:** Game cards with team matchups, confidence ratings, dates

---

### Screenshot 2: Game Detail View
**What to capture:** Detailed view of a single game prediction

**Steps:**
1. Tap on any game card from the home screen
2. Wait for detail view to load
3. Ensure team logos, stats comparison, and prediction details are visible
4. Press **Cmd + S** to save screenshot

**Filename:** `02_game_detail.png`
**Shows:** Team comparison, detailed statistics, confidence rating, odds

---

### Screenshot 3: Statistics Dashboard
**What to capture:** Performance tracking and accuracy metrics

**Steps:**
1. Tap the "Stats" tab at the bottom
2. Ensure charts and accuracy metrics are visible
3. Make sure the dashboard looks complete with data
4. Press **Cmd + S** to save screenshot

**Filename:** `03_stats_dashboard.png`
**Shows:** Accuracy percentage, performance charts, win/loss record

---

### Screenshot 4: Results Entry Screen
**What to capture:** Interface for entering game results

**Steps:**
1. Tap the "Results" tab at the bottom
2. Show the results entry interface
3. Display a few games where results can be entered
4. Press **Cmd + S** to save screenshot

**Filename:** `04_results_entry.png`
**Shows:** Game results input, score fields, teams

---

### Screenshot 5: Team Statistics
**What to capture:** Team-by-team breakdown view

**Steps:**
1. From Stats dashboard, find team-specific stats
2. Show breakdown by team or league-wide performance
3. Ensure visualizations are clear
4. Press **Cmd + S** to save screenshot

**Filename:** `05_team_stats.png`
**Shows:** Team performance breakdown, additional analytics

---

## Where Screenshots Are Saved

Screenshots are automatically saved to your **Desktop** as PNG files.

## After Capturing Screenshots

1. **Locate files** on your Desktop
2. **Rename them** according to the filenames above
3. **Move them** to a folder: `AppStoreAssets/Screenshots/`
4. **Review each screenshot** - make sure they're clear and representative

## Screenshot Requirements

### Technical Specs
- **Resolution:** 1290 x 2796 pixels (iPhone 15 Pro Max)
- **Format:** PNG or JPEG
- **Color Space:** RGB
- **No alpha channels**

### Content Guidelines
- ✓ Show actual app content
- ✓ Use realistic data
- ✓ Ensure text is readable
- ✓ Show app's best features
- ✗ No placeholder content
- ✗ No marketing overlays (for first set)
- ✗ No device frames needed

## Optional: Create Marketing Screenshots

You can also create enhanced screenshots with:
- Text overlays explaining features
- Device frames
- Backgrounds
- Feature callouts

Tools for this:
- **Screenshots.pro** (online)
- **Figma** (free design tool)
- **Previewed** (Mac app)

## Tips for Best Results

1. **Timing:** Capture when the app looks its best (full data, nice animations)
2. **Consistency:** Use same device type for all screenshots
3. **Clean:** Ensure status bar looks good (full battery, no weird icons)
4. **Data:** Make sure sample data looks realistic
5. **Order:** Screenshots show app flow from home to details to stats

## If You Don't Have Xcode Installed

You can use these alternatives:
1. **TestFlight:** Build the app and install on a real device, then take screenshots
2. **Real Device:** Use iPhone screenshot (Vol Up + Power button), then use Xcode to resize
3. **Simulator Recording:** Use QuickTime to record simulator, extract frames

## Simulator Status Bar

To clean up the status bar:
1. In Simulator menu: **Features → Status Bar**
2. Keep default (shows full battery, good signal)
3. Or customize to show ideal state

---

## Quick Reference: Screenshot Command

In iOS Simulator:
- **Cmd + S** = Save screenshot to Desktop
- **Cmd + 1** = Physical size (recommended)
- **Cmd + 2** = Point accurate
- **Cmd + 3** = Fit screen

---

## Next Steps After Screenshots

1. Upload screenshots to App Store Connect
2. Order them to tell your app's story
3. Add captions (optional)
4. Preview how they look in the App Store listing

