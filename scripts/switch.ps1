param(
  [ValidateSet("Light","Dark")]
  [string]$Mode = "Light",
  [string]$ProfilePath = ""
)
$ErrorActionPreference = "Stop"
if (-not $ProfilePath) {
  $candidates = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory | Where-Object { $_.Name -like "*.default-release" }
  if ($candidates.Count -eq 1) { $ProfilePath = $candidates[0].FullName }
  else { throw "Could not determine profile. Pass -ProfilePath." }
}
$chrome = Join-Path $ProfilePath "chrome"
$userChrome = Join-Path $chrome "userChrome.css"
if (-not (Test-Path $userChrome)) { throw "userChrome.css not found. Run install.ps1 first." }

$import = if ($Mode -eq "Dark") { '@import url("RetroFox2004/theme-dark.css");' } else { '@import url("RetroFox2004/theme.css");' }
# preserve other lines
$lines = Get-Content $userChrome | Where-Object { $_ -notmatch "RetroFox2004/theme" }
$new = @($import) + $lines
Set-Content -Path $userChrome -Value ($new -join "`n") -Encoding UTF8
Write-Host "Switched to $Mode edition. Restart Firefox (use -purgecaches if needed)."