# Kalshi Integration Guide

## Overview

Your EndZone Oracle NFL Predictions App now integrates with Kalshi, a federally regulated prediction market. This integration allows you to view real-time betting market odds alongside your AI predictions, helping you identify valuable betting opportunities.

## Features

✅ **Real-time Market Odds** - Fetch current Kalshi prediction market probabilities for NFL games  
✅ **Edge Detection** - Automatically calculate the difference between your predictions and market odds  
✅ **Value Bet Highlighting** - Visual indicators show when your model disagrees with the market  
✅ **Market Details** - View detailed market information including bid/ask spreads and volume  
✅ **Secure Storage** - API key stored securely on your device  

## Setup Instructions

### 1. Get Your Kalshi API Key

To use the Kalshi integration, you'll need an API key from Kalshi:

1. **Create a Kalshi Account**
   - Visit [kalshi.com](https://kalshi.com) and sign up
   - Complete the verification process

2. **Generate an API Key**
   - Log in to your Kalshi account
   - Navigate to **Settings** → **API** (or Developer section)
   - Click **Generate New API Key**
   - Copy the key immediately (you won't be able to see it again)

3. **Add the Key to the App**
   - Open the EndZone Oracle app
   - Tap **Settings** tab
   - Find the **Kalshi Integration** section
   - Toggle **Enable Kalshi Odds** ON
   - Tap **API Key**
   - Paste your API key
   - Tap **Save**

### 2. Enable Kalshi Odds

Once your API key is configured:

1. Ensure **Enable Kalshi Odds** toggle is ON in Settings
2. Return to the **Predictions** tab
3. The app will automatically fetch odds for your predictions
4. Pull down to refresh and get the latest odds

## How to Use

### Viewing Odds on Game Cards

When Kalshi odds are enabled, each game card will show:

- **Kalshi Market** indicator with the market probability
- **Market Title** - description of what the market represents
- **Edge Indicator** - shows if you have a value bet:
  - 🟢 **Value Bet** - Your model is more bullish than the market (5%+ edge)
  - 🔴 **Market Favors** - The market is more bullish than your model (5%+ edge)
  - 🟠 **Close Match** - Your prediction closely matches the market

### Understanding the Edge

The "edge" represents the difference between your model's probability and the market's probability:

- **Positive Edge (Value Bet)**: Your model predicts a higher chance of the team winning than the market. This could represent a betting opportunity.
- **Negative Edge (Market Favors)**: The market is more confident in the team than your model.
- **Small Edge**: Your prediction aligns closely with market consensus.

**Example:**
- Your model: Chiefs 65% win probability
- Kalshi market: Chiefs 55% win probability  
- Edge: +10% (Value Bet!)

### Viewing Market Details

Tap any game card to view detailed information including:
- Full market description
- Current bid/ask prices
- Trading volume
- Open interest
- Market status and expiration

## API Endpoints Used

The integration uses the Kalshi Trading API v2:

**Base URL:** `https://trading-api.kalshi.com`

**Endpoints:**
- `GET /trade-api/v2/markets` - Fetch NFL markets
- Parameters: `series_ticker`, `status`, `limit`

## Troubleshooting

### No Odds Showing Up

**Problem:** Kalshi odds section not appearing on game cards

**Solutions:**
1. Verify **Enable Kalshi Odds** is toggled ON in Settings
2. Check that your API key is saved correctly
3. Ensure you have an active internet connection
4. Pull down to refresh the predictions list
5. Check that Kalshi has markets for your games (they may not have markets for all matchups)

### "Invalid or missing API key" Error

**Problem:** Authentication error when fetching odds

**Solutions:**
1. Go to Settings → Kalshi Integration
2. Remove the current API key
3. Generate a fresh API key from Kalshi
4. Save the new key in the app

### "No Kalshi markets available" Message

**Problem:** No markets found for a specific matchup

**Possible Reasons:**
1. Kalshi may not have created markets for that game yet
2. The game may be too far in the future
3. Markets may have closed (game already started/completed)
4. Team name matching issue (less common)

### Slow Loading

**Problem:** Odds take a long time to load

**Solutions:**
1. Check your internet connection speed
2. Kalshi API may be experiencing high traffic
3. Try refreshing after a few moments
4. Restart the app if the issue persists

## Privacy & Security

- **Local Storage**: Your API key is stored securely in iOS UserDefaults on your device
- **No Sharing**: Your API key is never shared with third parties
- **HTTPS Only**: All API calls use secure HTTPS connections
- **Direct Connection**: The app connects directly to Kalshi (no intermediary servers)

## API Rate Limits

Kalshi may impose rate limits on API requests. The app:
- Fetches odds when predictions load
- Refreshes odds when you pull-to-refresh
- Caches results to minimize API calls

If you encounter rate limit errors, wait a few minutes before refreshing again.

## Technical Details

### Team Name Matching

The integration uses intelligent team name matching to link your predictions with Kalshi markets:

- Normalizes team names (removes "The", handles variations)
- Matches common nicknames (e.g., "49ers" vs "Niners")
- Searches market titles for team mentions

### Probability Calculation

Your model's implied probability is calculated from predicted scores:
```
Team Win Probability = Team Points / (Team Points + Opponent Points)
```

Kalshi market probability comes from the contract price:
```
Market Probability = Last Trade Price (in cents) / 100
```

### Edge Calculation

```
Edge = Your Probability - Market Probability
```

A 5% edge threshold is used for the value bet indicator.

## Future Enhancements

Planned features for future versions:
- Filter predictions to show only positive edges
- Track historical edge performance
- Support for additional market types (spreads, totals)
- Price alert notifications
- Direct links to Kalshi markets

## Support

For issues specific to:
- **The App Integration**: Check this guide and app settings
- **Kalshi API/Account**: Contact [Kalshi Support](https://kalshi.com/support)
- **API Documentation**: Visit Kalshi's developer documentation

## API Documentation References

- Kalshi Official Website: https://kalshi.com
- Kalshi Trading API: https://trading-api.kalshi.com/trade-api/v2/docs (if available)

---

**Last Updated**: October 15, 2025  
**App Version**: 1.0.0  
**Integration Version**: 1.0  

