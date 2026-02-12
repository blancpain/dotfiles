local spaces = require("hs.spaces")

local function ensureDesktops(desired)
	local screen = hs.screen.mainScreen()
	local currentSpaces = spaces.spacesForScreen(screen)
	for _ = #currentSpaces + 1, desired do
		spaces.addSpaceToScreen(screen, false)
	end
end

ensureDesktops(10)
