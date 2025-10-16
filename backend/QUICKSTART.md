# Quick Start - Deploy in 10 Minutes

Complete deployment guide for EndZone Oracle backend.

## Prerequisites

- Google Cloud account (free $300 credits for new users)
- Kalshi API credentials (Key ID + Private Key)
- 10 minutes

---

## Step 1: Install Google Cloud CLI (2 min)

```bash
# Install
brew install --cask google-cloud-sdk

# Initialize
gcloud init

# Login
gcloud auth login
```

---

## Step 2: Create GCP Project (1 min)

1. Go to https://console.cloud.google.com/
2. Click "New Project"
3. Name: `endzone-oracle-backend`
4. Click "Create"

```bash
# Set project
gcloud config set project endzone-oracle-backend
```

---

## Step 3: Enable APIs (1 min)

```bash
# Enable required services
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable secretmanager.googleapis.com
```

---

## Step 4: Store Your Kalshi Credentials (2 min)

```bash
# Store API Key ID
echo -n "YOUR_KALSHI_API_KEY_ID" | gcloud secrets create kalshi-api-key-id --data-file=-

# Store Private Key
echo -n "YOUR_KALSHI_PRIVATE_KEY" | gcloud secrets create kalshi-private-key --data-file=-

# Verify
gcloud secrets list
```

**Replace with your actual credentials!**

---

## Step 5: Deploy! (3 min)

```bash
cd /Users/ac09540/Desktop/Sports/NFLPredictionsApp/backend
./DEPLOY.sh
```

That's it! You'll see:
```
✅ Deployment complete!
🌐 Your API URL: https://us-central1-endzone-oracle-backend.cloudfunctions.net/kalshi-odds-api
```

---

## Step 6: Test Your API (1 min)

```bash
# Replace with your actual URL
curl "https://YOUR-FUNCTION-URL/kalshi-odds-api"
```

Expected response:
```json
{
  "success": true,
  "cached": false,
  "markets": [...]
}
```

---

## Next Steps

1. **Save your API URL** - you'll need it for the iOS app
2. **Update iOS app** to use this backend instead of direct Kalshi calls
3. **Remove Kalshi credentials** from iOS app (no longer needed per user)

---

## Troubleshooting

### Error: "Permission denied"
```bash
gcloud projects add-iam-policy-binding endzone-oracle-backend \
    --member="user:YOUR_EMAIL@gmail.com" \
    --role="roles/cloudfunctions.developer"
```

### Error: "Secrets not found"
Make sure you ran Step 4 with your actual credentials.

### Need help?
See [GCP_SETUP_GUIDE.md](./GCP_SETUP_GUIDE.md) for detailed instructions.

---

## What This Does

```
Before:
iOS App → Kalshi API (requires API keys per user) ❌

After:
iOS App → GCP Cloud Function → Kalshi API ✅
         (your credentials)
```

**Benefits:**
- ✅ Real-time odds for all users
- ✅ No API keys needed per user
- ✅ Free tier covers ~2M requests/month
- ✅ Auto-scales
- ✅ 5-minute caching for fast responses

---

## Cost

- **Free tier**: 2M requests/month
- **Your expected cost**: $0-2/month
- **Even with 5M requests/month**: ~$1.20/month

New users get **$300 free credits** for 90 days!

---

Ready to deploy? Run:
```bash
cd backend
./DEPLOY.sh
```
