# RetroFox2004 installer (Windows)
# Safe: backs up existing chrome/ customisations before changes.

param(
  [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
  [string]$ProfilePath = "",
  [ValidateSet("Light","Dark")]
  [string]$Edition = "Light"
)

$ErrorActionPreference = "Stop"

# Determine active profile if not provided
if (-not $ProfilePath) {
  $profilesIni = "$env:APPDATA\Mozilla\Firefox\profiles.ini"
  $installSection = Get-Content $profilesIni | Where-Object { $_ -match '^Default=' } | Select-Object -First 1
  # Fallback: use default-release profile
  $candidates = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory | Where-Object { $_.Name -like "*.default-release" }
  if ($candidates.Count -eq 1) { $ProfilePath = $candidates[0].FullName }
  else { throw "Could not determine profile. Pass -ProfilePath." }
}

if (-not (Test-Path $ProfilePath)) { throw "Profile not found: $ProfilePath" }
Write-Host "Using profile: $ProfilePath"

$chrome = Join-Path $ProfilePath "chrome"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backup = Join-Path $ProfilePath "chrome_backup_RetroFox2004_$timestamp"

# Backup existing chrome folder
if (Test-Path $chrome) {
  Write-Host "Backing up existing chrome to $backup"
  Copy-Item $chrome $backup -Recurse -Force
} else {
  New-Item -ItemType Directory -Path $chrome | Out-Null
}

# Copy RetroFox2004 folder
$srcTheme = Join-Path $ProjectRoot "chrome\RetroFox2004"
if (-not (Test-Path $srcTheme)) { throw "Theme folder not found: $srcTheme" }
$dstTheme = Join-Path $chrome "RetroFox2004"
if (Test-Path $dstTheme) { Remove-Item $dstTheme -Recurse -Force }
Copy-Item $srcTheme $dstTheme -Recurse -Force
Write-Host "Copied RetroFox2004 theme."

# Handle userChrome.css
$userChrome = Join-Path $chrome "userChrome.css"
$importLine = if ($Edition -eq "Dark") { '@import url("RetroFox2004/theme-dark.css");' } else { '@import url("RetroFox2004/theme.css");' }
if (Test-Path $userChrome) {
  $content = Get-Content $userChrome -Raw
  if ($content -notmatch [regex]::Escape($importLine)) {
    # prepend import
    $new = $importLine + "`n" + $content
    Set-Content -Path $userChrome -Value $new -Encoding UTF8
    Write-Host "Added import to existing userChrome.css (backup in chrome_backup)."
  } else {
    Write-Host "Import already present in userChrome.css."
  }
} else {
  Set-Content -Path $userChrome -Value $importLine -Encoding UTF8
  Write-Host "Created userChrome.css."
}

# Ensure pref enabled via user.js
$userJs = Join-Path $ProfilePath "user.js"
$prefLine = 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
if (Test-Path $userJs) {
  $content = Get-Content $userJs -Raw
  if ($content -notmatch "legacyUserProfileCustomizations.stylesheets") {
    Add-Content -Path $userJs -Value $prefLine
    Write-Host "Enabled userChrome.css pref via user.js."
  }
} else {
  Set-Content -Path $userJs -Value $prefLine -Encoding UTF8
  Write-Host "Created user.js with pref."
}

Write-Host ""
Write-Host "Installation complete."
Write-Host "Restart Firefox. If styles do not appear, restart with -purgecaches or clear startup cache."
Write-Host "Backup location: $backup"