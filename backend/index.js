/**
 * EndZone Oracle Backend API
 * GCP Cloud Function to serve Kalshi odds to all app users
 *
 * Environment Variables (from GCP Secret Manager):
 * - KALSHI_API_KEY_ID: Your Kalshi API Key ID
 * - KALSHI_PRIVATE_KEY: Your Kalshi Private Key
 */

const fetch = require('node-fetch');

// Configuration
const KALSHI_BASE_URL = 'https://trading-api.kalshi.com';
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes cache
const NFL_SERIES_TICKERS = ['NFL', 'FOOTBALL', 'NFLGAME'];

// In-memory cache (persists across invocations in warm containers)
const cache = {
  data: null,
  timestamp: null
};

/**
 * Main Cloud Function entry point
 * GET /kalshi-odds-api
 * Query params:
 *   - team1: Filter for specific team (optional)
 *   - team2: Filter for specific team (optional)
 *   - refresh: Force cache refresh (optional, value: "true")
 */
exports.getOdds = async (req, res) => {
  // Enable CORS for iOS app
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight
  if (req.method === 'OPTIONS') {
    return res.status(204).send('');
  }

  // Only allow GET requests
  if (req.method !== 'GET') {
    return res.status(405).json({
      success: false,
      error: 'Method not allowed. Use GET.'
    });
  }

  try {
    const { team1, team2, refresh } = req.query;
    const forceRefresh = refresh === 'true';

    console.log(`Request received - team1: ${team1}, team2: ${team2}, refresh: ${forceRefresh}`);

    // Check cache
    const now = Date.now();
    const cacheValid = cache.data && cache.timestamp && (now - cache.timestamp < CACHE_TTL);

    let markets;
    let fromCache = false;

    if (cacheValid && !forceRefresh) {
      console.log('Serving from cache');
      markets = cache.data;
      fromCache = true;
    } else {
      console.log('Fetching fresh data from Kalshi');
      markets = await fetchNFLMarkets();

      // Update cache
      cache.data = markets;
      cache.timestamp = now;
    }

    // Filter by teams if specified
    let filteredMarkets = markets;
    if (team1 || team2) {
      filteredMarkets = filterMarketsByTeams(markets, team1, team2);
      console.log(`Filtered ${markets.length} markets to ${filteredMarkets.length} for teams: ${team1}, ${team2}`);
    }

    // Return response
    res.status(200).json({
      success: true,
      cached: fromCache,
      timestamp: new Date().toISOString(),
      cacheAge: fromCache ? Math.floor((now - cache.timestamp) / 1000) : 0,
      totalMarkets: markets.length,
      filteredMarkets: filteredMarkets.length,
      markets: filteredMarkets
    });

  } catch (error) {
    console.error('Error fetching odds:', error);

    res.status(500).json({
      success: false,
      error: error.message || 'Failed to fetch odds',
      timestamp: new Date().toISOString()
    });
  }
};

/**
 * Fetch all NFL markets from Kalshi
 */
async function fetchNFLMarkets() {
  const apiKeyId = process.env.KALSHI_API_KEY_ID;
  const privateKey = process.env.KALSHI_PRIVATE_KEY;

  if (!apiKeyId || !privateKey) {
    throw new Error('Kalshi API credentials not configured. Check Secret Manager.');
  }

  let allMarkets = [];

  // Try different series tickers
  for (const ticker of NFL_SERIES_TICKERS) {
    try {
      const markets = await fetchMarketsForSeries(ticker, apiKeyId, privateKey);
      console.log(`Found ${markets.length} markets for series: ${ticker}`);
      allMarkets = allMarkets.concat(markets);
    } catch (error) {
      console.warn(`Failed to fetch markets for ${ticker}:`, error.message);
      // Continue with other tickers
    }
  }

  console.log(`Total NFL markets fetched: ${allMarkets.length}`);
  return allMarkets;
}

/**
 * Fetch markets for a specific series ticker
 */
async function fetchMarketsForSeries(seriesTicker, apiKeyId, privateKey) {
  const url = `${KALSHI_BASE_URL}/trade-api/v2/markets?series_ticker=${seriesTicker}&limit=200&status=open`;

  const headers = {
    'Content-Type': 'application/json',
    'X-Kalshi-Api-Key-Id': apiKeyId
  };

  // Note: Full RSA signature authentication would go here
  // For now, trying with just the API Key ID
  // Kalshi's full auth requires signing the request with the private key
  // Format: KALSHI-ECDSA-SHA256 Signature=<base64_signature>, Timestamp=<timestamp>

  const response = await fetch(url, {
    method: 'GET',
    headers: headers,
    timeout: 30000
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`Kalshi API error (${response.status}): ${errorText}`);
  }

  const data = await response.json();
  return data.markets || [];
}

/**
 * Filter markets by team names
 */
function filterMarketsByTeams(markets, team1, team2) {
  const teams = [team1, team2].filter(Boolean).map(t => t.toLowerCase());

  if (teams.length === 0) {
    return markets;
  }

  return markets.filter(market => {
    const titleLower = market.title.toLowerCase();
    const tickerLower = market.ticker.toLowerCase();

    return teams.some(team =>
      titleLower.includes(team) ||
      tickerLower.includes(team) ||
      matchesTeamVariations(titleLower, team) ||
      matchesTeamVariations(tickerLower, team)
    );
  });
}

/**
 * Match team name variations (e.g., "Steelers", "PIT", "Pittsburgh")
 */
function matchesTeamVariations(text, teamName) {
  const teamMap = {
    // AFC East
    'bills': ['buffalo', 'buf'],
    'dolphins': ['miami', 'mia'],
    'patriots': ['new england', 'ne', 'pats'],
    'jets': ['new york jets', 'nyj'],

    // AFC North
    'ravens': ['baltimore', 'bal'],
    'bengals': ['cincinnati', 'cin'],
    'browns': ['cleveland', 'cle'],
    'steelers': ['pittsburgh', 'pit'],

    // AFC South
    'texans': ['houston', 'hou'],
    'colts': ['indianapolis', 'ind'],
    'jaguars': ['jacksonville', 'jax', 'jags'],
    'titans': ['tennessee', 'ten'],

    // AFC West
    'broncos': ['denver', 'den'],
    'chiefs': ['kansas city', 'kc', 'kansas'],
    'raiders': ['las vegas', 'lv', 'oakland'],
    'chargers': ['los angeles chargers', 'lac', 'la chargers'],

    // NFC East
    'cowboys': ['dallas', 'dal'],
    'giants': ['new york giants', 'nyg', 'ny giants'],
    'eagles': ['philadelphia', 'phi', 'philly'],
    'commanders': ['washington', 'was', 'wsh'],

    // NFC North
    'bears': ['chicago', 'chi'],
    'lions': ['detroit', 'det'],
    'packers': ['green bay', 'gb'],
    'vikings': ['minnesota', 'min'],

    // NFC South
    'falcons': ['atlanta', 'atl'],
    'panthers': ['carolina', 'car'],
    'saints': ['new orleans', 'no', 'nola'],
    'buccaneers': ['tampa bay', 'tb', 'tampa', 'bucs'],

    // NFC West
    'cardinals': ['arizona', 'ari'],
    'rams': ['los angeles rams', 'lar', 'la rams'],
    'seahawks': ['seattle', 'sea'],
    '49ers': ['san francisco', 'sf', 'niners', 'forty niners']
  };

  const normalizedTeam = teamName.toLowerCase().trim();

  // Check if the team name matches any key or variation
  for (const [key, variations] of Object.entries(teamMap)) {
    if (normalizedTeam.includes(key) || variations.some(v => normalizedTeam.includes(v))) {
      // Found the team - check if text matches any variation
      return text.includes(key) || variations.some(v => text.includes(v));
    }
  }

  // Direct match as fallback
  return text.includes(normalizedTeam);
}

/**
 * Health check endpoint
 */
exports.healthCheck = async (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    cache: {
      hasData: !!cache.data,
      age: cache.timestamp ? Math.floor((Date.now() - cache.timestamp) / 1000) : null
    }
  });
};
