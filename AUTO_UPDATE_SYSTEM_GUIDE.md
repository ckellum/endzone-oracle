# Auto-Update System Guide - EndZone Oracle

## 🎯 How It Works

Your app now **automatically fetches the latest predictions from GitHub** every week. Users don't need to update the app - they get fresh predictions automatically!

---

## 📱 User Experience

### **What Users See:**

1. **App Launch:**
   - App opens
   - Automatically checks GitHub for latest predictions.json
   - Downloads new predictions if available
   - Shows predictions immediately

2. **Weekly Updates:**
   - Every 7 days, app auto-fetches latest predictions
   - No manual action required
   - Seamless experience

3. **Manual Refresh:**
   - Users can go to Settings
   - Tap "Refresh from GitHub" button
   - Get latest predictions immediately

4. **Offline Mode:**
   - If offline, uses cached predictions
   - If no cache, uses bundled predictions
   - Always works!

---

## 🔄 Update Flow

```
App Launch
    ↓
Check GitHub for predictions.json
    ↓
    ├─→ Success: Load new predictions
    │   └─→ Cache locally
    │   └─→ Display to user
    │
    ├─→ Network Error: Load from cache
    │   └─→ Display cached predictions
    │
    └─→ No Cache: Load bundled predictions
        └─→ Display bundled predictions
```

---

## 👨‍💻 Your Workflow (Updating Predictions)

### **Every Monday (or when new predictions are ready):**

**Option 1: Using the Script (Recommended)**

```bash
# 1. Navigate to project
cd /Users/ac09540/Desktop/Sports/NFLPredictionsApp

# 2. Update predictions.json with new data
./update-predictions.sh ~/Downloads/your-new-predictions.json

# 3. Done! Script automatically:
#    - Backs up old file
#    - Updates predictions.json
#    - Commits to Git
#    - Pushes to GitHub
```

**Option 2: Manual in Cursor**

1. Replace `EndZone Oracle/NFLPredictions/predictions.json` with new file
2. Commit and push to GitHub
3. Done!

### **What Happens Next:**

- ✅ predictions.json is now on GitHub
- ✅ All users' apps will auto-download it within 7 days
- ✅ Users on Settings can manually refresh immediately
- ✅ No app update needed!

---

## 🔧 Technical Details

### **GitHub URL:**

The app fetches from:
```
https://raw.githubusercontent.com/ckellum/endzone-oracle/main/EndZone%20Oracle/NFLPredictions/predictions.json
```

### **Update Frequency:**

- **Automatic:** Every 7 days
- **Manual:** User can trigger anytime via Settings
- **On Launch:** Always checks if 7+ days since last update

### **Caching:**

- Downloaded predictions are cached locally
- If network fails, uses cache
- Cache persists between app launches
- No internet? No problem!

### **Fallback Chain:**

1. **Try GitHub** (latest from internet)
2. **Try Cache** (previously downloaded)
3. **Use Bundle** (included with app)

---

## 📂 Files Involved

### **In Your Project:**

```
EndZone Oracle/NFLPredictions/
├── predictions.json              ← Update this file weekly
├── Services/
│   ├── GitHubPredictionsService.swift  ← Fetches from GitHub
│   └── PredictionService.swift         ← Manages predictions
└── App/
    └── ContentView.swift         ← Auto-loads on app launch
```

### **User's Device:**

```
UserDefaults:
├── cachedPredictions             ← Downloaded predictions
└── lastPredictionsUpdate         ← Last update timestamp
```

---

## 🎮 Testing the System

### **Test GitHub Fetch:**

1. **Run the app in simulator**
2. **Watch the console** - should see:
   ```
   Fetching predictions from GitHub...
   ✅ Downloaded 15 games
   ```

3. **Go to Settings** → verify "Timestamp" shows current data

### **Test Cache:**

1. **Turn off Wi-Fi** on Mac
2. **Run app again**
3. **Should load cached predictions** (no internet needed)

### **Test Manual Refresh:**

1. **Go to Settings** in the app
2. **Tap "Refresh from GitHub"**
3. **Watch spinner** → should complete
4. **Check predictions** are updated

### **Test Update Script:**

```bash
cd /Users/ac09540/Desktop/Sports/NFLPredictionsApp
./update-predictions.sh ~/Downloads/test-predictions.json
```

Should see success messages and push to GitHub.

---

## 💡 Advantages of This System

### **For Users:**

✅ **Always Fresh Data**
- Get new predictions weekly
- No app update required
- Automatic background updates

✅ **Works Offline**
- Uses cached predictions
- Always functional
- No internet? No problem!

✅ **Manual Control**
- Can force refresh anytime
- See when last updated
- Full transparency

### **For You:**

✅ **Easy Updates**
- Just push predictions.json to GitHub
- One command with script
- Instant deployment to all users

✅ **No App Store Review**
- Update data without resubmitting app
- Faster content updates
- No waiting for Apple approval

✅ **Version Control**
- Full Git history of predictions
- Can roll back if needed
- Track changes over time

✅ **Scalable**
- Works for 1 user or 100,000 users
- GitHub handles distribution
- No backend server needed

---

## 🔒 Privacy & Security

**What's Stored:**

- Downloaded predictions (JSON data)
- Last update timestamp
- All stored locally on device

**Network Calls:**

- Only to GitHub (public repository)
- HTTPS encrypted
- No tracking or analytics
- No personal data transmitted

**Permissions:**

- No special permissions required
- Uses standard URL loading
- Fully transparent to users

---

## 🚨 Troubleshooting

### **App Not Updating:**

**Check:**
1. Is predictions.json on GitHub? (visit the raw URL)
2. Is it valid JSON? (test at jsonlint.com)
3. Has it been 7+ days since last update?
4. Try manual refresh in Settings

### **GitHub Fetch Fails:**

**Possible Causes:**
- Network connectivity issue
- GitHub is down (rare)
- Invalid JSON format
- Wrong repository URL

**Solution:**
- App automatically falls back to cache
- Users won't notice the failure
- Fix predictions.json and users get it next time

### **Users Report Old Data:**

**Check:**
1. When was predictions.json last updated on GitHub?
2. Ask user to manually refresh in Settings
3. Check "Last Updated" in Settings tab

### **Script Won't Push:**

```bash
# Check git status
cd /Users/ac09540/Desktop/Sports/NFLPredictionsApp
git status

# Pull latest
git pull

# Try push again
git push
```

---

## 📊 Monitoring Updates

### **Check If Users Have Latest:**

In the app Settings tab, users can see:
- **Timestamp:** When predictions were generated
- **Generated:** Exact date/time
- **Loaded Predictions:** Number of games

### **Verify GitHub Has Latest:**

Visit: https://github.com/ckellum/endzone-oracle/blob/main/EndZone%20Oracle/NFLPredictions/predictions.json

Check the "Last modified" date.

### **Test Raw URL:**

Visit: https://raw.githubusercontent.com/ckellum/endzone-oracle/main/EndZone%20Oracle/NFLPredictions/predictions.json

Should show latest JSON data.

---

## 🎓 Best Practices

### **Weekly Updates:**

**Monday Morning:**
1. Generate/receive new predictions
2. Run update script
3. Verify push to GitHub
4. Test in app (optional)
5. Users get updates automatically!

### **Emergency Updates:**

If you need to update mid-week:
1. Update predictions.json
2. Push to GitHub
3. Notify users to manually refresh in Settings
4. Or wait for automatic weekly check

### **Season Changes:**

- Playoffs: Update more frequently
- Off-season: Use script to archive old predictions
- New season: Update with Week 1 games

### **Quality Control:**

Before pushing:
- ✅ Validate JSON format
- ✅ Check game count is correct
- ✅ Verify team names match
- ✅ Test in simulator first

---

## 📱 User Instructions (What to Tell Users)

> **"Get Fresh Predictions Every Week!"**
>
> Your EndZone Oracle app automatically downloads the latest NFL predictions each week. No app update needed!
>
> **Want the latest predictions right now?**
> 1. Open the app
> 2. Go to Settings tab
> 3. Tap "Refresh from GitHub"
> 4. Done!
>
> **Works offline too!** If you're without internet, the app uses previously downloaded predictions.

---

## 🔄 Update Schedule

### **Automatic (Users):**

- **Every 7 days:** App checks for updates
- **On app launch:** If 7+ days passed
- **Background:** Happens automatically

### **Manual (You):**

- **Weekly:** Monday mornings (or when predictions ready)
- **Special events:** Playoffs, primetime games
- **Emergency:** Anytime via script or Cursor

---

## 🎉 Summary

**What You Do:**
1. Update predictions.json on GitHub (one command)

**What Happens Automatically:**
1. All users get new predictions within 7 days
2. Users can manually refresh anytime
3. Works offline with cached data
4. No app update required

**Result:**
- ✅ Users always have fresh predictions
- ✅ You control content from GitHub
- ✅ No App Store resubmission needed
- ✅ Instant deployment to all users

---

## 📚 Related Files

- **Update Script:** `update-predictions.sh`
- **GitHub Service:** `GitHubPredictionsService.swift`
- **Prediction Service:** `PredictionService.swift`
- **Quick Reference:** `QUICK_UPDATE_REFERENCE.txt`

---

**Your app now updates itself automatically!** 🚀

Just push predictions.json to GitHub weekly and all users get fresh data.

Last Updated: October 16, 2025
