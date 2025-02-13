#!/bin/bash

# Path to Windows Terminal settings.json
WIN_USER=$(powershell.exe -NoProfile -Command "[System.Environment]::UserName" | tr -d '\r')
SETTINGS_PATH="/mnt/c/Users/${WIN_USER}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

# Detect Windows color mode using PowerShell
THEME=$(powershell.exe -NoProfile -Command "& {Get-ItemPropertyValue -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize' -Name AppsUseLightTheme}")

# Remove carriage return (^M) from Windows output
THEME=$(echo "$THEME" | tr -d '\r')

# Determine color scheme
if [[ "$THEME" == "0" ]]; then
    NEW_COLOR_SCHEME="One Half Dark"
else
    NEW_COLOR_SCHEME="One Half Light"
fi

# Use jq to update settings.json
jq --arg scheme "$NEW_COLOR_SCHEME" \
  '(.profiles.list[] | select(.name == "Ubuntu") | .colorScheme) = $scheme' \
   "$SETTINGS_PATH" > /tmp/settings.json

# Overwrite the original settings.json
mv /tmp/settings.json "$SETTINGS_PATH"

echo "Switched Windows Terminal theme to: $NEW_COLOR_SCHEME"

