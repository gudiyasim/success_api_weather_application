# Weather demo (OpenWeatherMap)

This small project demonstrates fetching current weather from OpenWeatherMap while keeping the API key in a local `.env` file. The Node/Express server proxies requests to OpenWeatherMap so the key is not embedded in client-side code.

Quick start

1. Copy `.env.example` to `.env` and set your `OPENWEATHER_API_KEY`.

```
copy .env.example .env
```

2. Install dependencies and start the server:

```bash
npm install
npm start
```

3. Open http://localhost:3000 in your browser. Select a city and click "Get Weather".

Windows helper scripts

If `npm` isn't available in your PowerShell path or port 3000 is already in use, use the included helper scripts:

- `run-server.ps1` — PowerShell script that frees port 3000 (if occupied) and starts `server.js` using the installed Node executable. Run:

```powershell
.\run-server.ps1
# Or specify a port:
.\run-server.ps1 -Port 4000
```

- `run-server.bat` — Windows batch wrapper that invokes the PowerShell helper:

```cmd
run-server.bat
```

These helpers attempt to detect and stop any process using the configured port before starting the server.

Files

- `server.js` — Express server and proxy endpoint `/api/weather?lat=&lon=`.
- `index.html` — UI and layout.
- `js/main.js` — Client logic to load cities and request weather.
- `city_coordinates.csv` — list of available cities.
