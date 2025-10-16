# Kalshi Integration - Quick Start

## Getting Started in 5 Minutes

### Step 1: Configure Your API Key (2 minutes)

1. Open the app
2. Tap **Settings** (bottom right)
3. Find **Kalshi Integration** section
4. Toggle **Enable Kalshi Odds** to ON
5. Tap **API Key**
6. Paste your Kalshi API key
7. Tap **Save**

> **Don't have an API key yet?** See the full [Kalshi Integration Guide](KALSHI_INTEGRATION_GUIDE.md) for instructions on obtaining one from Kalshi.

### Step 2: View Odds (1 minute)

1. Go back to **Predictions** tab
2. Wait a few seconds for odds to load
3. Pull down to refresh if needed

### Step 3: Understand What You're Seeing

Each game card now shows:

```
📊 Kalshi Market          65%
Will the Chiefs win against the Raiders?

🟢 Value Bet: 10.0%
```

**What this means:**
- The Kalshi prediction market gives the Chiefs a 65% chance to win
- Your model predicts a higher probability
- There's a 10% "edge" (potential value bet)

## Color Guide

- 🟢 **Green (Value Bet)**: Your model is more bullish than the market (5%+ difference)
- 🟠 **Orange (Close Match)**: Your prediction closely matches the market
- 🔴 **Red (Market Favors)**: The market is more bullish than your model

## Testing the Integration

### Quick Test Checklist

✅ Enable Kalshi odds in Settings  
✅ Save your API key  
✅ Return to Predictions tab  
✅ See "Kalshi Market" section on game cards  
✅ Pull to refresh to update odds  
✅ Tap a game card to see full market details  

### Expected Behavior

**When Working Correctly:**
- Kalshi odds appear within 3-5 seconds
- Each game shows market probability
- Edge indicators display (green/orange/red)
- Pull-to-refresh updates odds

**Potential Issues:**
- "No Kalshi markets available" - Normal for some games
- Loading takes >10 seconds - Check internet connection
- Error message - Verify API key is correct

## API Endpoints Reference

The app queries these Kalshi API endpoints:

```
Base URL: https://trading-api.kalshi.com

GET /trade-api/v2/markets?series_ticker=NFL&limit=200
GET /trade-api/v2/markets?series_ticker=FOOTBALL&limit=200
GET /trade-api/v2/markets?series_ticker=NFLGAME&limit=200
```

The app tries multiple series tickers to find NFL markets, as Kalshi's naming convention may vary.

## Troubleshooting Quick Fixes

### Problem: No odds showing

**Fix 1:** Check Settings
- Go to Settings → Kalshi Integration
- Ensure toggle is ON and API key is saved

**Fix 2:** Refresh
- Pull down on Predictions list
- Tap Settings then back to Predictions

**Fix 3:** Restart app
- Close and reopen the app

### Problem: "Invalid API key" error

**Fix:** Update API key
1. Go to Kalshi website
2. Generate new API key
3. Settings → Kalshi Integration → API Key
4. Paste new key and save

### Problem: Only some games have odds

**This is normal!** Kalshi may not have markets for all games. Markets are created based on demand and timing.

## Understanding the Data

### Market Probability
The percentage shown is derived from Kalshi's contract price:
- 60% = Contract trading at ¢60 (out of ¢100)
- Higher % = Market thinks team is more likely to win

### Your Model's Probability
Calculated from predicted scores:
```
Team Win % = Team Points / Total Points
Example: 26 points out of 46 total = 56.5%
```

### The Edge
```
Edge = Your Probability - Market Probability
Example: 56.5% - 60% = -3.5% (Market Favors)
Example: 65% - 55% = +10% (Value Bet)
```

## Next Steps

Once you've confirmed the integration works:

1. **Explore Markets**: Tap game cards to see detailed market information
2. **Track Performance**: Note which "value bets" actually win
3. **Adjust Threshold**: The 5% edge threshold is configurable in future versions
4. **Compare Results**: See how your predictions stack up against the market

## Privacy Note

Your Kalshi API key is:
- ✅ Stored only on your device
- ✅ Sent only to Kalshi's official API
- ✅ Never transmitted to third parties
- ✅ Can be removed anytime in Settings

## Need More Help?

See the comprehensive [Kalshi Integration Guide](KALSHI_INTEGRATION_GUIDE.md) for:
- Detailed setup instructions
- Advanced features
- Technical documentation
- Full troubleshooting guide

---

**Quick Support:**
- App integration issues: Check Settings and refresh
- Kalshi account/API issues: Contact Kalshi Support
- General questions: See KALSHI_INTEGRATION_GUIDE.md

