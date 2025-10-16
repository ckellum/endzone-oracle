#!/bin/bash

# Test script for Kalshi API
# This will show you what markets are available

API_KEY_ID="YOUR_API_KEY_ID_HERE"
BASE_URL="https://api.elections.kalshi.com"

echo "Testing Kalshi API..."
echo "Base URL: $BASE_URL"
echo ""

# Test 1: Get all open markets (first 10)
echo "=== Test 1: Fetching open markets ==="
curl -s "${BASE_URL}/trade-api/v2/markets?status=open&limit=10" \
  -H "KALSHI-ACCESS-KEY: ${API_KEY_ID}" \
  | python3 -m json.tool | head -50

echo ""
echo "=== Test 2: Search for NFL markets ==="
# Try different series tickers
for ticker in "KXMVENFLSINGLEGAME" "KXMVENFLMULTIGAMEEXTENDED" "NFL" "FOOTBALL"; do
  echo "Trying series_ticker: $ticker"
  count=$(curl -s "${BASE_URL}/trade-api/v2/markets?series_ticker=${ticker}&status=open&limit=200" \
    -H "KALSHI-ACCESS-KEY: ${API_KEY_ID}" \
    | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data.get('markets', [])))" 2>/dev/null || echo "0")
  echo "  Found $count markets"
done

echo ""
echo "=== Test 3: Get events (to see what's available) ==="
curl -s "${BASE_URL}/trade-api/v2/events?limit=20&status=open" \
  -H "KALSHI-ACCESS-KEY: ${API_KEY_ID}" \
  | python3 -m json.tool | grep -E '"(event_ticker|title|series_ticker)"' | head -30
