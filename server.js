const express = require('express');
const axios = require('axios');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;
const API_KEY = process.env.OPENWEATHER_API_KEY;

if (!API_KEY) {
  console.warn('Warning: OPENWEATHER_API_KEY not set in .env');
}

app.use(express.static(path.join(__dirname)));

app.get('/api/weather', async (req, res) => {
  const { lat, lon } = req.query;
  if (!lat || !lon) return res.status(400).json({ error: 'lat and lon required' });

  if (!API_KEY) {
    // Clear, actionable error when server not configured with API key
    return res.status(500).json({
      error: 'Server misconfigured: OPENWEATHER_API_KEY missing',
      hint: 'Copy .env.example to .env and set OPENWEATHER_API_KEY with your OpenWeatherMap API key'
    });
  }

  try {
    const url = `https://api.openweathermap.org/data/2.5/weather?lat=${encodeURIComponent(lat)}&lon=${encodeURIComponent(lon)}&appid=${API_KEY}`;
    const response = await axios.get(url);
    res.json(response.data);
  } catch (err) {
    console.error(err?.response?.data || err.message || err);
    const status = err?.response?.status || 500;
    // Forward provider error details where possible to help debugging
    const details = err?.response?.data || err.message;
    res.status(status).json({ error: 'Failed to fetch weather', details });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
