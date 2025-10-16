# Weekly Predictions Update Guide

This guide explains how to update your app with new NFL predictions each week.

---

## 🎯 Overview

Your app now uses a standardized **`predictions.json`** file that you can update weekly with new game predictions. The old timestamped files have been replaced with this single, easy-to-update file.

---

## 📁 File Structure

```
EndZone Oracle/
└── NFLPredictions/
    ├── predictions.json           ← Active predictions (update this weekly)
    ├── enhanced_predictions_*.json ← Old files (can be deleted)
    └── ...

predictions_archive/               ← Auto-created by update script
    ├── predictions_20251016.json  ← Backed up automatically
    └── predictions_20251023.json
```

---

## 🔄 Two Ways to Update Predictions

### **Method 1: Automated Script (Recommended)**

Use the provided script to update predictions with one command.

**Steps:**

1. **Get your new predictions JSON file**
   - Place it anywhere (e.g., Downloads folder)
   - Example: `enhanced_predictions_20251023_120000.json`

2. **Run the update script**

   Open Terminal and run:
   ```bash
   cd /Users/ac09540/Desktop/Sports/NFLPredictionsApp
   ./update-predictions.sh ~/Downloads/your-new-predictions.json
   ```

   Replace `your-new-predictions.json` with your actual filename.

3. **The script will:**
   - ✅ Validate the JSON file
   - ✅ Archive the current predictions.json
   - ✅ Update predictions.json with new data
   - ✅ Commit to Git
   - ✅ Push to GitHub
   - ✅ Show you a summary

4. **Rebuild the app in Xcode**
   - Open the project in Xcode
   - Press Cmd + R to build and run
   - New predictions will load automatically!

---

### **Method 2: Manual Update**

If you prefer to do it manually:

**Steps:**

1. **Backup current predictions**
   ```bash
   cd "/Users/ac09540/Desktop/Sports/NFLPredictionsApp"
   cp "EndZone Oracle/NFLPredictions/predictions.json" \
      "predictions_archive/predictions_$(date +%Y%m%d).json"
   ```

2. **Replace with new predictions**
   ```bash
   cp ~/Downloads/your-new-predictions.json \
      "EndZone Oracle/NFLPredictions/predictions.json"
   ```

3. **Commit to Git**
   ```bash
   git add "EndZone Oracle/NFLPredictions/predictions.json"
   git commit -m "Update weekly predictions - $(date +%Y-%m-%d)"
   git push
   ```

4. **Rebuild in Xcode**

---

## 🎬 Using Cursor to Update

You can also update directly in Cursor:

1. **Replace the file**
   - Open Cursor
   - Navigate to: `EndZone Oracle/NFLPredictions/`
   - Delete `predictions.json`
   - Drag your new JSON file and rename it to `predictions.json`

2. **Commit & Push**
   - Press **Cmd + Shift + G** (open Source Control)
   - Click **+** to stage changes
   - Type commit message: "Update weekly predictions"
   - Press **Cmd + Enter** to commit
   - Click **sync button** (↻) to push

3. **Rebuild the app**
   - Open project in Xcode
   - Press Cmd + R

---

## 📋 Weekly Workflow Checklist

Use this checklist every week:

**Monday (or whenever new predictions are ready):**

- [ ] Receive/generate new predictions JSON file
- [ ] Verify the JSON is valid (open in a text editor)
- [ ] Run update script: `./update-predictions.sh <new-file>`
- [ ] Verify script completed successfully
- [ ] Open Xcode and build the app (Cmd + R)
- [ ] Test in simulator - verify new games appear
- [ ] Verify predictions count is correct
- [ ] Check GitHub - confirm push succeeded

**Optional - Archive cleanup:**
- [ ] Review `predictions_archive/` folder monthly
- [ ] Keep recent backups, delete very old ones

---

## 🔍 Verifying the Update

After updating, verify everything worked:

### **In the App:**

1. **Open the app in simulator**
2. **Go to Settings tab**
3. **Check "Current Model" section:**
   - Verify "Timestamp" is current week
   - Verify "Generated" date is recent
   - Check "Loaded Predictions" count matches

4. **Go to Predictions tab**
   - Verify you see the new games
   - Check team names and matchups are correct

### **On GitHub:**

1. Go to: https://github.com/ckellum/endzone-oracle
2. Check recent commits
3. Verify "Update weekly predictions" commit is there
4. Click on `predictions.json` file
5. Verify it shows the new data

---

## 🛠️ Script Details

### **What the update-predictions.sh script does:**

```bash
./update-predictions.sh <new-predictions-file>
```

**Actions:**
1. Validates new JSON file is properly formatted
2. Archives current predictions.json (timestamped backup)
3. Copies new file to predictions.json
4. Shows summary of new predictions (game count, date)
5. Commits to Git with descriptive message
6. Pushes to GitHub automatically
7. Shows success confirmation

**Safety features:**
- ✅ Validates JSON before replacing
- ✅ Always creates backup before updating
- ✅ Shows clear error messages
- ✅ Won't overwrite if something goes wrong

---

## 📊 JSON File Format

Your predictions.json should follow this structure:

```json
{
  "generated_at": "2025-10-23T08:00:00.000000",
  "timestamp": "20251023_080000",
  "model_version": "EnhancedNFLPredictionModel_v1.0",
  "data_sources": {
    "offensive_stats": "nfl_offensive_stats_YYYYMMDD.csv",
    "defensive_stats": "nfl_defensive_stats_YYYYMMDD.csv"
  },
  "statistics": {
    "total_games": 15,
    "avg_total_points": 44.5,
    ...
  },
  "predictions": [
    {
      "team1": "Kansas City Chiefs",
      "team1_predicted_points": 28,
      "team2": "Buffalo Bills",
      "team2_predicted_points": 24,
      "predicted_winner": "Kansas City Chiefs",
      "point_differential": 4,
      "total_points": 52
    },
    ...
  ]
}
```

**Required fields:**
- `generated_at` - ISO timestamp
- `timestamp` - Format: YYYYMMDD_HHMMSS
- `predictions` - Array of game predictions
  - Each prediction needs: team1, team2, predicted_winner, points

---

## 🚨 Troubleshooting

### **Script says "Invalid JSON file"**
- Open the JSON file in a text editor
- Check for syntax errors (missing commas, brackets)
- Validate at: https://jsonlint.com/
- Fix any errors and try again

### **Script says "File not found"**
- Check the file path is correct
- Use tab-completion in terminal
- Try dragging the file into terminal to get exact path

### **Git push fails**
- Run: `git pull` first to get latest changes
- Then run: `git push` again
- Or use GitHub Desktop to sync

### **App doesn't show new predictions**
- Clean build in Xcode: Product → Clean Build Folder (Shift+Cmd+K)
- Rebuild: Cmd + R
- Check Settings tab - verify model timestamp updated
- Try "Load Latest Predictions" button in Settings

### **Archive folder getting too large**
- Old backups are in: `predictions_archive/`
- Safe to delete old backups (keep last 4-5 weeks)
- Archives are just for your reference

---

## 📱 Adding to Xcode Project

The `predictions.json` file should already be in your Xcode project. If it's not showing:

1. **In Xcode:**
   - Right-click on `NFLPredictions` folder
   - Click "Add Files to 'EndZone Oracle'..."
   - Navigate to `predictions.json`
   - Check "Copy items if needed"
   - Click "Add"

2. **Verify it's added:**
   - Look in Project Navigator (left sidebar)
   - `predictions.json` should appear in the NFLPredictions group
   - Build the project - should work without errors

---

## 🎓 Pro Tips

**Tip 1: Automate Weekly Updates**
- Set a calendar reminder each Monday
- Download new predictions
- Run the script
- Push to GitHub
- Takes < 2 minutes!

**Tip 2: Test Before Pushing**
- Always build and test in simulator first
- Verify predictions look correct
- Then push to GitHub

**Tip 3: Keep Backups**
- The script auto-creates backups
- Keep last month of backups
- Useful if you need to roll back

**Tip 4: Use Git Branches**
- For major updates, create a branch
- Test thoroughly
- Merge to main when ready

**Tip 5: Archive Organization**
```
predictions_archive/
├── 2025_october/
│   ├── predictions_20251007.json
│   ├── predictions_20251014.json
│   └── predictions_20251021.json
└── 2025_november/
    └── predictions_20251104.json
```

---

## 📅 Season Schedule

**Regular updates:**
- **Monday/Tuesday:** Get new predictions for upcoming week
- **Run update script**
- **Test in app**
- **Push to GitHub**

**Mid-season:**
- Check prediction accuracy
- Update model if needed
- Keep archives organized

**Playoffs:**
- Update more frequently
- Smaller game counts
- Same process!

---

## 🎉 Benefits of This System

✅ **Simple:** One file to update (`predictions.json`)
✅ **Safe:** Automatic backups before each update
✅ **Fast:** Script handles everything (< 30 seconds)
✅ **Versioned:** All updates tracked in Git
✅ **Reliable:** JSON validation before updating
✅ **Portable:** Works on any computer with Git

---

## 📞 Support

**If you run into issues:**

1. Check this guide's troubleshooting section
2. Verify JSON is valid at jsonlint.com
3. Check Git status: `git status`
4. Look at script output for error messages
5. Ask me for help!

---

## 📚 Related Files

- **Update Script:** `update-predictions.sh`
- **Predictions File:** `EndZone Oracle/NFLPredictions/predictions.json`
- **Archives:** `predictions_archive/`
- **Git Guide:** `CURSOR_GIT_GUIDE.md`

---

**Happy predicting! Your weekly updates are now streamlined.** 🏈

Last Updated: October 16, 2025
