#!/bin/bash

# EndZone Oracle Backend Deployment Script
# Deploys Cloud Function to GCP

set -e  # Exit on error

echo "🚀 Deploying EndZone Oracle Backend to GCP Cloud Functions"
echo "=========================================================="
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ Error: gcloud CLI not found"
    echo "   Install it with: brew install --cask google-cloud-sdk"
    exit 1
fi

# Check if logged in
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
    echo "❌ Error: Not logged in to gcloud"
    echo "   Run: gcloud auth login"
    exit 1
fi

# Get project ID
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    echo "❌ Error: No GCP project set"
    echo "   Run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "✅ Deploying to project: $PROJECT_ID"
echo ""

# Check if secrets exist
echo "🔍 Checking for Kalshi API secrets..."
if ! gcloud secrets describe kalshi-api-key-id &> /dev/null; then
    echo "❌ Error: Secret 'kalshi-api-key-id' not found"
    echo "   Create it with:"
    echo "   echo -n 'YOUR_KEY' | gcloud secrets create kalshi-api-key-id --data-file=-"
    exit 1
fi

if ! gcloud secrets describe kalshi-private-key &> /dev/null; then
    echo "❌ Error: Secret 'kalshi-private-key' not found"
    echo "   Create it with:"
    echo "   echo -n 'YOUR_KEY' | gcloud secrets create kalshi-private-key --data-file=-"
    exit 1
fi

echo "✅ Secrets found"
echo ""

# Deploy function
echo "🚀 Deploying Cloud Function..."
echo ""

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

echo ""
echo "✅ Deployment complete!"
echo ""

# Get function URL
FUNCTION_URL=$(gcloud functions describe kalshi-odds-api --region=us-central1 --gen2 --format="value(serviceConfig.uri)" 2>/dev/null)

if [ -n "$FUNCTION_URL" ]; then
    echo "🌐 Your API URL:"
    echo "   $FUNCTION_URL"
    echo ""
    echo "📋 Test your API:"
    echo "   curl \"$FUNCTION_URL\""
    echo ""
    echo "🔧 Next steps:"
    echo "   1. Test the API with curl"
    echo "   2. Update iOS app with this URL"
    echo "   3. Remove Kalshi API keys from iOS app"
else
    echo "⚠️  Could not retrieve function URL"
    echo "   View it at: https://console.cloud.google.com/functions"
fi

echo ""
echo "📊 View logs:"
echo "   gcloud functions logs read kalshi-odds-api --limit=50"
echo ""
echo "📈 View metrics:"
echo "   https://console.cloud.google.com/functions/details/us-central1/kalshi-odds-api"
echo ""
