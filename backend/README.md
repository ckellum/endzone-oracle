# EndZone Oracle Backend

Backend API for serving Kalshi odds to all EndZone Oracle app users without requiring individual API keys.

## Quick Start

### 1. Install Google Cloud CLI
```bash
brew install --cask google-cloud-sdk
gcloud init
gcloud auth login
```

### 2. Set up GCP Project
```bash
gcloud config set project endzone-oracle-backend
```

### 3. Store Kalshi Credentials in Secret Manager
```bash
echo -n "YOUR_KALSHI_API_KEY_ID" | gcloud secrets create kalshi-api-key-id --data-file=-
echo -n "YOUR_KALSHI_PRIVATE_KEY" | gcloud secrets create kalshi-private-key --data-file=-
```

### 4. Deploy Cloud Function
```bash
cd backend
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

### 5. Test Your API
```bash
# Get all NFL markets
curl "https://YOUR-FUNCTION-URL/kalshi-odds-api"

# Get odds for specific teams
curl "https://YOUR-FUNCTION-URL/kalshi-odds-api?team1=Steelers&team2=Bengals"

# Force refresh cache
curl "https://YOUR-FUNCTION-URL/kalshi-odds-api?refresh=true"
```

## API Endpoints

### GET /kalshi-odds-api

Fetch NFL market odds from Kalshi.

**Query Parameters:**
- `team1` (optional): Filter for specific team
- `team2` (optional): Filter for another team
- `refresh` (optional): Force cache refresh (`true`/`false`)

**Response:**
```json
{
  "success": true,
  "cached": false,
  "timestamp": "2025-10-16T14:30:00Z",
  "cacheAge": 0,
  "totalMarkets": 150,
  "filteredMarkets": 2,
  "markets": [
    {
      "ticker": "NFL-STEELERS-WIN-2025",
      "title": "Will the Steelers win against the Bengals?",
      "yes_price": 0.35,
      "no_price": 0.65,
      "volume": 12500,
      "open_interest": 8900,
      "close_time": "2025-10-20T00:00:00Z"
    }
  ]
}
```

## Caching

- **Cache Duration**: 5 minutes (configurable in `index.js`)
- **Purpose**: Reduces Kalshi API calls and improves response time
- **Behavior**:
  - First request fetches from Kalshi (~500ms)
  - Subsequent requests served from cache (~50ms)
  - Cache automatically refreshes after TTL expires

## Monitoring

### View Logs
```bash
gcloud functions logs read kalshi-odds-api --limit=50
```

### View Metrics
```bash
# Open in browser
https://console.cloud.google.com/functions/details/us-central1/kalshi-odds-api
```

### Update Function
```bash
gcloud functions deploy kalshi-odds-api --source=.
```

## Cost Estimate

- **Free Tier**: 2M requests/month
- **After Free Tier**: $0.40 per million requests
- **Typical Cost**: $0-2/month for most usage

## Architecture

```
iOS App (All Users)
    ↓
GCP Cloud Function (Your Kalshi Keys)
    ↓
Kalshi API
```

**Benefits:**
- ✅ Real-time odds
- ✅ No API keys required per user
- ✅ Auto-scales
- ✅ Built-in caching
- ✅ Free tier covers most usage

## Security

- ✅ API keys stored in GCP Secret Manager
- ✅ HTTPS only (automatic)
- ✅ CORS enabled for iOS app
- ✅ Rate limiting via GCP

## Support

See [GCP_SETUP_GUIDE.md](./GCP_SETUP_GUIDE.md) for detailed setup instructions.
