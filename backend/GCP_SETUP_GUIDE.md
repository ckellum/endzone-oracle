# GCP Cloud Functions Backend Setup Guide

Complete step-by-step guide to deploy a backend API for serving Kalshi odds to all app users.

## Architecture Overview

```
iOS App → GCP Cloud Function → Kalshi API
                ↓
           Cache Layer (reduces API calls)
                ↓
           Returns odds to all users
```

**Benefits:**
- Real-time odds updates
- No API keys required per user
- Auto-scales with usage
- Free tier: 2M requests/month
- Built-in caching to reduce Kalshi API calls

---

## Step 1: GCP Account Setup

### 1.1 Create GCP Account
1. Go to https://cloud.google.com/
2. Click **"Get started for free"**
3. Sign in with your Google account (cjkellum@gmail.com)
4. Enter billing information
   - **New users get $300 free credits** (valid for 90 days)
   - After credits, Cloud Functions has a generous free tier

### 1.2 Create New Project
1. Go to https://console.cloud.google.com/
2. Click the project dropdown (top left)
3. Click **"New Project"**
4. Name it: `endzone-oracle-backend`
5. Click **"Create"**

---

## Step 2: Enable Required APIs

1. In GCP Console, go to **"APIs & Services"** → **"Enable APIs and Services"**
2. Search and enable:
   - ✅ **Cloud Functions API**
   - ✅ **Cloud Build API**
   - ✅ **Cloud Run Admin API**
   - ✅ **Secret Manager API** (for storing Kalshi API keys securely)

---

## Step 3: Install Google Cloud CLI

### On macOS:
```bash
# Install gcloud CLI
brew install --cask google-cloud-sdk

# Initialize and authenticate
gcloud init

# Login
gcloud auth login

# Set project
gcloud config set project endzone-oracle-backend
```

### Verify Installation:
```bash
gcloud --version
# Should show: Google Cloud SDK 4xx.x.x
```

---

## Step 4: Store Kalshi API Keys Securely

Use GCP Secret Manager to store your Kalshi credentials:

```bash
# Enable Secret Manager API
gcloud services enable secretmanager.googleapis.com

# Create secret for Kalshi API Key ID
echo -n "YOUR_KALSHI_API_KEY_ID" | gcloud secrets create kalshi-api-key-id \
    --data-file=-

# Create secret for Kalshi Private Key
echo -n "YOUR_KALSHI_PRIVATE_KEY" | gcloud secrets create kalshi-private-key \
    --data-file=-

# Verify secrets were created
gcloud secrets list
```

**Replace:**
- `YOUR_KALSHI_API_KEY_ID` with your actual Kalshi API Key ID
- `YOUR_KALSHI_PRIVATE_KEY` with your actual Kalshi Private Key

---

## Step 5: Deploy Cloud Function

### 5.1 Navigate to backend directory
```bash
cd /Users/ac09540/Desktop/Sports/NFLPredictionsApp/backend
```

### 5.2 Deploy the function
```bash
gcloud functions deploy kalshi-odds-api \
    --gen2 \
    --runtime=nodejs20 \
    --region=us-central1 \
    --source=. \
    --entry-point=getOdds \
    --trigger-http \
    --allow-unauthenticated \
    --set-secrets='KALSHI_API_KEY_ID=kalshi-api-key-id:latest,KALSHI_PRIVATE_KEY=kalshi-private-key:latest' \
    --timeout=60s \
    --memory=256MB
```

**Parameters explained:**
- `--gen2`: Use 2nd generation Cloud Functions (better performance)
- `--runtime=nodejs20`: Use Node.js 20
- `--region=us-central1`: Deploy in US Central (good latency for US users)
- `--allow-unauthenticated`: Allow public access (no auth required)
- `--set-secrets`: Inject Kalshi credentials from Secret Manager
- `--timeout=60s`: Max execution time
- `--memory=256MB`: Memory allocation (can increase if needed)

### 5.3 Get your API URL
After deployment completes, you'll see:
```
Service URL: https://us-central1-endzone-oracle-backend.cloudfunctions.net/kalshi-odds-api
```

**Save this URL** - you'll need it in the iOS app!

---

## Step 6: Test Your API

### Test with curl:
```bash
# Get all NFL markets
curl "https://YOUR-FUNCTION-URL/kalshi-odds-api"

# Get odds for specific teams
curl "https://YOUR-FUNCTION-URL/kalshi-odds-api?team1=Steelers&team2=Bengals"
```

### Expected Response:
```json
{
  "success": true,
  "cached": false,
  "timestamp": "2025-10-16T14:30:00Z",
  "markets": [
    {
      "ticker": "NFL-STEELERS-WIN-2025",
      "title": "Will the Steelers win?",
      "yes_price": 0.35,
      "no_price": 0.65,
      ...
    }
  ]
}
```

---

## Step 7: Monitor and Manage

### View Logs:
```bash
gcloud functions logs read kalshi-odds-api --limit=50
```

### View Metrics (invocations, latency, errors):
1. Go to https://console.cloud.google.com/functions
2. Click on `kalshi-odds-api`
3. Click **"Metrics"** tab

### Update Function (after code changes):
```bash
cd /Users/ac09540/Desktop/Sports/NFLPredictionsApp/backend
gcloud functions deploy kalshi-odds-api --source=.
```

---

## Step 8: Set Up Caching (Reduce Kalshi API Calls)

The Cloud Function includes built-in caching:
- **Cache duration**: 5 minutes (configurable)
- **Reduces cost**: Kalshi API called once per 5 min instead of per request
- **Faster responses**: Cached responses return in ~50ms vs ~500ms

To adjust cache duration, edit `index.js`:
```javascript
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes (change as needed)
```

---

## Pricing Estimate

### Free Tier (per month):
- 2M requests
- 400,000 GB-seconds compute time
- 200,000 GHz-seconds compute time
- 5GB egress (data transfer out)

### After Free Tier:
- **Requests**: $0.40 per million
- **Compute time**: $0.0000025 per GB-second
- **Egress**: $0.12 per GB

### Example Cost:
- **10,000 users**, each checking odds **3 times/day**
- = 900,000 requests/month
- = **$0** (within free tier)

Even with 5M requests/month:
- First 2M free
- Next 3M = $1.20
- **Total: $1.20/month**

---

## Security Best Practices

✅ **Implemented:**
- API keys stored in Secret Manager (not in code)
- CORS configured to allow your iOS app
- Rate limiting via GCP (automatic)
- HTTPS only (automatic)

🔒 **Optional Enhancements:**
1. **Add API key authentication** (prevent abuse):
   ```bash
   # App sends header: X-API-Key: your-secret-key
   ```

2. **Restrict to your domain** (after you have a website):
   ```bash
   gcloud functions deploy ... --ingress-settings=internal-and-gclb
   ```

3. **Set up Cloud Armor** (DDoS protection):
   - Enable if you get popular

---

## Troubleshooting

### Error: "Permission denied"
```bash
# Grant yourself permission to deploy functions
gcloud projects add-iam-policy-binding endzone-oracle-backend \
    --member="user:cjkellum@gmail.com" \
    --role="roles/cloudfunctions.developer"
```

### Error: "Secrets not found"
```bash
# Verify secrets exist
gcloud secrets list

# Recreate if needed (see Step 4)
```

### Error: "Build failed"
```bash
# Check logs
gcloud builds list --limit=5
gcloud builds log [BUILD_ID]
```

### Function times out
```bash
# Increase timeout to 120s
gcloud functions deploy kalshi-odds-api --timeout=120s
```

---

## Next Steps

After deployment:
1. ✅ Save your Cloud Function URL
2. ✅ Test the API with curl
3. ✅ Update iOS app to use the new backend
4. ✅ Remove KalshiService direct API calls from iOS app
5. ✅ Update App Store metadata (mention real-time odds)

---

## Maintenance

### Weekly:
- Check logs for errors: `gcloud functions logs read kalshi-odds-api`
- Monitor costs: https://console.cloud.google.com/billing

### Monthly:
- Review metrics and optimize cache duration
- Check for GCP updates

### When Kalshi API credentials change:
```bash
# Update secrets
echo -n "NEW_KEY" | gcloud secrets versions add kalshi-api-key-id --data-file=-
```

---

## Architecture Diagram

```
┌─────────────────┐
│   iOS App       │
│  (All Users)    │
└────────┬────────┘
         │
         │ HTTPS GET /kalshi-odds-api?team1=X&team2=Y
         │
         ▼
┌─────────────────────────────────────┐
│  GCP Cloud Function                 │
│  ┌───────────────────────────────┐  │
│  │  1. Check cache               │  │
│  │  2. If expired, call Kalshi   │  │
│  │  3. Store in cache (5 min)    │  │
│  │  4. Return odds to app        │  │
│  └───────────────────────────────┘  │
└────────┬────────────────────────────┘
         │
         │ Authenticated request with YOUR API keys
         │
         ▼
┌─────────────────┐
│  Kalshi API     │
│  (Markets data) │
└─────────────────┘
```

**Key Points:**
- ✅ Users never see or need Kalshi API keys
- ✅ Your credentials stored securely in GCP Secret Manager
- ✅ Caching reduces Kalshi API calls (saves money + faster)
- ✅ Scales automatically with user growth
- ✅ Free for most usage levels

---

## Support

- GCP Documentation: https://cloud.google.com/functions/docs
- GCP Pricing Calculator: https://cloud.google.com/products/calculator
- Kalshi API Docs: https://trading-api.readme.io/
