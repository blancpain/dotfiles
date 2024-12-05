#!/usr/bin/env bash

# To get the names of all the running applications
# yabai -m query --windows | jq -r '.[].app'

# Can add transparent apps below
# apps_transparent="(Spotify|kitty|Neovide|Google Chrome|Code|WezTerm|Ghostty)"

# Apps that I want to always show, even when I have a transparent app focused
apps_transp_ignore="(Firefox)"

# Apps excluded from window management, so you can resize them and move them around
# This is basically the ignore list

# I had to move them away from normal, because all these apps would stay on top
# of other apps
# apps_mgoff_normal="()"

# This keeps apps always below, seems to be working fine when I switch to other
# apps_mgoff_below="(Calculator|iStat Menus|Hammerspoon|BetterDisplay|GIMP|Notes|Activity Monitor|App StoreSoftware Update|CleanShot X|TestRig|Gemini|Raycast|OBS Studio|Cisco Packet Tracer|Stickies|kitty|ProLevel|Photo Booth|Hand Mirror|SteerMouse)"

# This keeps apps always on the top
# apps_mgoff_above="()"
