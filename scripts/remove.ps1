# RetroFox2004 remover
param(
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

if (Test-Path $userChrome) {
  $content = Get-Content $userChrome -Raw
  # Remove both Classic and Dark import lines (and trailing blank lines)
  $content = $content -replace '@import url\("RetroFox2004/theme[^"]*\.css"\);\s*', ""
  if ($content.Trim() -eq "") {
    Remove-Item $userChrome -Force
    Write-Host "Removed userChrome.css (was only RetroFox import)."
  } else {
    Set-Content -Path $userChrome -Value $content.Trim() -Encoding UTF8
    Write-Host "Removed RetroFox import from userChrome.css."
  }
}

$themeDir = Join-Path $chrome "RetroFox2004"
if (Test-Path $themeDir) {
  Remove-Item $themeDir -Recurse -Force
  Write-Host "Removed RetroFox2004 folder."
}

# Remove pref line from user.js (optional)
$userJs = Join-Path $ProfilePath "user.js"
if (Test-Path $userJs) {
  $lines = Get-Content $userJs | Where-Object { $_ -notmatch "legacyUserProfileCustomizations.stylesheets" }
  if ($lines.Count -eq 0) { Remove-Item $userJs -Force } else { Set-Content -Path $userJs -Value $lines -Encoding UTF8 }
  Write-Host "Cleaned user.js pref."
}

Write-Host "Removal complete. Restart Firefox."