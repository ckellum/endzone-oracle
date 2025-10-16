# NFL Predictions iOS App

A premium, modern iOS app built with SwiftUI that displays NFL game predictions from your machine learning model. Features comprehensive success rate tracking, beautiful UI, and detailed analytics.

## 📱 Features

### Core Features
- ✅ **JSON Import & Parsing** - Load predictions from JSON files
- 🎨 **Beautiful Game Cards** - Premium card-based UI with team colors and helmets
- 📊 **Statistics Dashboard** - Comprehensive analytics and performance tracking
- ✏️ **Results Entry** - Manual score entry for completed games
- 🎯 **Accuracy Tracking** - Real-time calculation of prediction accuracy
- 🔍 **Filter & Sort** - Multiple sorting and filtering options
- 📈 **Performance Charts** - Visual representation of accuracy over time
- 🏈 **32 NFL Teams** - Complete team data with colors and branding

### UI Highlights
- Dark mode support
- Smooth animations and transitions
- Pull-to-refresh functionality
- Haptic feedback
- Confidence level indicators
- Team-specific statistics
- Best/worst prediction insights

## 🏗️ Architecture

### Tech Stack
- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Minimum iOS**: 17.0+
- **Architecture**: MVVM (Model-View-ViewModel)
- **Persistence**: CoreData
- **Charts**: Swift Charts framework

### Project Structure
```
NFLPredictions/
├── App/                          # App entry point and main views
│   ├── NFLPredictionsApp.swift  # Main app struct
│   └── ContentView.swift         # Root tab view
├── Models/                       # Data models
│   ├── PredictionData.swift     # Root JSON model
│   ├── Prediction.swift         # Single prediction model
│   └── GameResult.swift         # Actual game result model
├── ViewModels/                   # Business logic
│   ├── PredictionsViewModel.swift
│   ├── StatsViewModel.swift
│   └── ResultsViewModel.swift
├── Views/                        # SwiftUI views
│   ├── Home/                    # Predictions list
│   ├── Detail/                  # Game details
│   ├── Stats/                   # Statistics dashboard
│   ├── Results/                 # Results entry
│   ├── Settings/                # Settings
│   └── Components/              # Reusable components
├── Services/                     # Data services
│   ├── PredictionService.swift
│   ├── DataPersistenceService.swift
│   └── AnalyticsService.swift
└── Utilities/                    # Helper code
    ├── NFLTeams.swift           # Team data
    └── Extensions/              # Swift extensions
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- macOS Sonoma 14.0 or later
- iOS 17.0+ device or simulator

### Installation

1. **Open the project in Xcode**:
   ```bash
   cd NFLPredictionsApp
   open NFLPredictions.xcodeproj
   ```
   
   If the `.xcodeproj` file doesn't exist, create one:
   - Open Xcode
   - File → New → Project
   - Choose "iOS" → "App"
   - Product Name: `NFLPredictions`
   - Interface: SwiftUI
   - Language: Swift
   - Storage: Core Data
   - Save in the `NFLPredictionsApp` directory

2. **Add the source files to your project**:
   - In Xcode, right-click on the project navigator
   - Select "Add Files to NFLPredictions"
   - Add all the folders (App, Models, Views, etc.)
   - Ensure "Copy items if needed" is checked

3. **Configure the CoreData model**:
   - The `NFLPredictions.xcdatamodeld` folder contains the data model
   - Ensure it's included in your Xcode project
   - If you created a new project, replace the default data model with the provided one

4. **Add team helmet images** (Optional but recommended):
   - Create an Asset Catalog: `Assets.xcassets`
   - For each team, add a helmet image with the naming convention:
     - `bills`, `dolphins`, `patriots`, `jets`, etc.
   - Recommended size: 512x512 pt with transparent background
   - The app will show placeholder icons if images aren't available

5. **Build and Run**:
   - Select a simulator or device
   - Press `Cmd + R` to build and run

## 📝 JSON Format

The app expects predictions in the following JSON format:

```json
{
  "generated_at": "2025-10-14T16:01:58.087500",
  "timestamp": "20251014_160158",
  "model_version": "EnhancedNFLPredictionModel_v1.0",
  "data_sources": {
    "offensive_stats": "nfl_offensive_stats.csv",
    "defensive_stats": "nfl_defensive_stats.csv"
  },
  "statistics": {
    "total_games": 15,
    "outliers_detected": 0,
    "avg_total_points": 45.4,
    "min_total_points": 38,
    "max_total_points": 56,
    "avg_point_differential": 3.0,
    "max_spread": 10,
    "games_with_ties": 2,
    "games_40_50_points": 10
  },
  "predictions": [
    {
      "team1": "Pittsburgh Steelers",
      "team1_predicted_points": 21,
      "team2": "Cincinnati Bengals",
      "team2_predicted_points": 18,
      "predicted_winner": "Pittsburgh Steelers",
      "point_differential": 3,
      "total_points": 39
    }
  ]
}
```

### Team Names
Use exact team names as defined in `NFLTeams.swift`:
- Buffalo Bills
- Miami Dolphins
- New England Patriots
- New York Jets
- Baltimore Ravens
- Cincinnati Bengals
- Cleveland Browns
- Pittsburgh Steelers
- Houston Texans
- Indianapolis Colts
- Jacksonville Jaguars
- Tennessee Titans
- Denver Broncos
- Kansas City Chiefs
- Las Vegas Raiders
- Los Angeles Chargers
- Dallas Cowboys
- New York Giants
- Philadelphia Eagles
- Washington Commanders
- Chicago Bears
- Detroit Lions
- Green Bay Packers
- Minnesota Vikings
- Atlanta Falcons
- Carolina Panthers
- New Orleans Saints
- Tampa Bay Buccaneers
- Arizona Cardinals
- Los Angeles Rams
- San Francisco 49ers
- Seattle Seahawks

## 📖 Usage

### Importing Predictions

1. **From Home Screen**:
   - Tap the download icon in the navigation bar
   - Select a JSON file from Files app
   - Predictions will load automatically

2. **From Settings**:
   - Go to Settings tab
   - Tap "Import Predictions"
   - Select your JSON file

3. **Sample Data**:
   - On the home screen empty state
   - Tap "Load Sample Data" for testing

### Entering Results

**Method 1: From Game Card**
- Tap any prediction card
- In the detail view, tap "Enter Game Result"
- Use steppers to set actual scores
- Tap "Save"

**Method 2: Bulk Entry**
- Not yet implemented in UI, but `ResultsEntryView` is available
- Can be added to navigation toolbar if needed

### Viewing Statistics

Navigate to the **Stats** tab to see:
- Overall accuracy percentage
- Total games, correct/incorrect predictions
- Current and best streaks
- Average point errors
- Performance over time chart
- Team-specific statistics
- Best and worst predictions

### Filtering & Sorting

Tap the filter icon (≡) in the navigation bar:

**Sort Options**:
- Point Differential (high confidence first)
- Total Points (highest scoring games)
- Team Name (alphabetical)

**Filter Options**:
- All Games
- Completed (games with results)
- Scheduled (games without results)
- High Confidence (large point differential)

## 🎨 Customization

### Team Colors
Edit `Utilities/NFLTeams.swift` to customize team colors:
```swift
NFLTeam(name: "Pittsburgh Steelers", 
        abbreviation: "PIT", 
        primaryColor: Color(hex: "FFB612"),
        secondaryColor: Color(hex: "000000"),
        helmetAssetName: "steelers")
```

### App Colors
Edit `Utilities/Extensions/Color+Extensions.swift`:
```swift
static let appPrimary = Color(hex: "007AFF")
static let appSecondary = Color(hex: "5856D6")
static let appAccent = Color(hex: "FF9500")
```

### Confidence Levels
Adjust thresholds in `Models/Prediction.swift`:
```swift
var confidenceLevel: ConfidenceLevel {
    let absDiff = abs(pointDifferential)
    switch absDiff {
    case 0...3: return .low
    case 4...7: return .medium
    default: return .high
    }
}
```

## 🧪 Testing

### Preview Data
Most views include SwiftUI previews. To see them:
- Open any View file in Xcode
- Press `Opt + Cmd + Return` to show preview canvas
- Click "Resume" if preview is paused

### Sample Data
The app includes a sample data loader:
```swift
viewModel.loadSampleData()
```

## 🐛 Troubleshooting

### Common Issues

**1. "Cannot find type 'NFLPredictions' in scope"**
- Ensure the CoreData model file is included in your project
- Clean build folder: `Cmd + Shift + K`
- Rebuild: `Cmd + B`

**2. "Missing helmet images"**
- The app works without images (shows placeholders)
- To add images, place them in Assets.xcassets with correct naming

**3. "Failed to load CoreData"**
- Delete app from simulator/device
- Clean build folder
- Rebuild and reinstall

**4. JSON import fails**
- Verify JSON matches exact structure
- Check team names match exactly
- Ensure file is valid JSON

**5. Charts not displaying**
- Requires iOS 17.0+
- Import Charts framework in `PerformanceChartView.swift`

## 🔜 Future Enhancements

### Planned Features
- [ ] Home Screen Widgets (small, medium, large)
- [ ] Push notifications for game times
- [ ] Share predictions as images
- [ ] Favorites system for teams
- [ ] Dark/light mode toggle in settings
- [ ] Export historical data
- [ ] Import from URL
- [ ] Multiple prediction sources
- [ ] Comparison between model versions

### Nice to Have
- [ ] Live score integration (ESPN API)
- [ ] Vegas odds comparison
- [ ] Historical season view
- [ ] Player performance integration
- [ ] Weather data correlation
- [ ] Social sharing features
- [ ] iCloud sync

## 📄 License

This project is provided as-is for personal use. NFL team names, logos, and trademarks are property of the NFL and respective teams.

## 🙏 Acknowledgments

- NFL team data and colors sourced from official team websites
- SwiftUI framework by Apple
- CoreData persistence framework
- Swift Charts for data visualization

## 📧 Support

For issues or questions about the app, please refer to the code comments and documentation within each file.

---

**Built with ❤️ using SwiftUI**

Enjoy tracking your NFL predictions! 🏈


