param(
  [int]$Port = 3000
)

Write-Output "Ensuring port $Port is free..."

$existingPid = $null
try {
  $conn = Get-NetTCPConnection -LocalPort $Port -ErrorAction Stop | Select-Object -First 1
  if ($conn) { $existingPid = $conn.OwningProcess }
} catch {
  $net = netstat -aon | Select-String ":$Port\s"
  if ($net) {
    $m = ($net -split '\s+')[-1]
    [int]$existingPid = $m
  }
}

if ($existingPid) {
  Write-Output "Killing process $existingPid using port $Port..."
  try {
    Stop-Process -Id $existingPid -Force -ErrorAction Stop
    Write-Output "Process $existingPid terminated."
  } catch {
    Write-Warning ("Failed to kill process {0}: {1}" -f $existingPid, $_)
  }
  Start-Sleep -Milliseconds 500
}

$node = 'C:\Program Files\nodejs\node.exe'
if (-Not (Test-Path $node)) {
  try { $node = (Get-Command node -ErrorAction Stop).Source } catch { $node = $null }
}

if (-Not $node) {
  Write-Error "node not found. Ensure Node.js is installed and available in PATH or update the script to point to the node executable."
  exit 1
}

Write-Output "Starting server with $node server.js ..."
$proc = Start-Process -FilePath $node -ArgumentList "server.js" -WorkingDirectory (Get-Location) -NoNewWindow -PassThru

# wait for server to respond
$tries = 0
while ($tries -lt 20) {
  try {
    $r = Invoke-WebRequest -Uri "http://localhost:$Port" -UseBasicParsing -TimeoutSec 2
    if ($r.StatusCode -eq 200) {
      Write-Output "Server is up at http://localhost:$Port (PID $($proc.Id))"
      exit 0
    }
  } catch {}
  Start-Sleep -Milliseconds 500
  $tries++
}

Write-Output "Server started (PID $($proc.Id)) but did not respond within timeout. Check logs in this terminal or visit http://localhost:$Port to verify."
exit 0
