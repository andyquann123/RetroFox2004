# RetroFox 2004 v1.0.0 — Release Notes

## Overview

RetroFox 2004 restores the look and feel of Mozilla Firefox 1.0 (November 2004) on modern Firefox using genuine Mozilla Winstripe artwork and the `userChrome.css` customisation system.

Cosmetic only — Firefox is not downgraded and remains fully updated.

## Editions

- **Classic Edition** — faithful light theme with original green Back/Forward arrows, blue Reload, red Stop, colourful Home and classic grey toolbars.
- **Dark Edition** — dark charcoal/graphite interface with the same original colourful Winstripe icons.

## Installation requirements

- Windows Firefox (tested on Firefox 158.0.1)
- `toolkit.legacyUserProfileCustomizations.stylesheets` set to `true` in `about:config`
- No administrator privileges required

## Installation

1. Exit Firefox completely.
2. Open your Firefox profile folder (`about:support` → "Open Folder" beside Profile Folder).
3. Copy the `chrome` folder from this release into your profile folder.
4. Restart Firefox.

The installer script (`scripts/install.ps1`) automates this and backs up any existing `chrome/` folder.

## Switching editions

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\switch.ps1" -Mode Dark
powershell -ExecutionPolicy Bypass -File "scripts\switch.ps1" -Mode Light
```

## Uninstallation

```powershell
powershell -ExecutionPolicy Bypass -File "scripts\remove.ps1"
```

## Known limitations

- Mozilla does not officially support `userChrome.css`; future Firefox updates may require selector updates.
- Some modern Firefox features (tabs, menus) are approximated, not pixel-perfect.
- The theme styles the browser interface only, not websites.
- Menu Bar must be enabled manually (right-click toolbar → Menu Bar).
- Home button may need to be added via "Customize Toolbar".
- Works best with Firefox's default System theme; other themes may conflict.

## Licensing

- Project code and scripts: MIT License.
- Original Mozilla Winstripe artwork: MPL 1.1 / GPL 2.0 / LGPL 2.1 (see `LICENSE-ORIGINAL.txt`).
- Mozilla and Firefox are trademarks of the Mozilla Foundation. This is an independent community project, not affiliated with or endorsed by Mozilla.

## Credits

- Original Winstripe artwork by Stephen Horlander and Kevin Gerich (Mozilla), extracted from Firefox 1.0's `chrome/classic.jar`.
- RetroFox 2004 theme and tooling by the RetroFox 2004 project.