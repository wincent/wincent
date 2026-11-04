-- vim: ft=lua
-- Space Gray Eighties theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
-- Scheme System: base24
-- Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)
--
-- Imports this scheme into every Rex app running on this machine and switches
-- the app to the scheme's appearance. Run it with the Rex CLI, for example as a
-- tinty hook:
--
--     hook = "rex --autostart=false do %f"
--
-- Rex can only import theme files from the app's own machine, so apps connected
-- to the Rex server from another machine are skipped. Run tinty there too.

local name = "base24-space-gray-eighties"
local variant = "dark"

-- This must match themes/ghostty/base24-space-gray-eighties exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Space Gray Eighties theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#212121
palette = 1=#ec5f67
palette = 2=#80a763
palette = 3=#4d83d0
palette = 4=#5485c0
palette = 5=#bf83c0
palette = 6=#57c2c0
palette = 7=#c7c6c2
palette = 8=#7b7a79
palette = 9=#ff6973
palette = 10=#93d393
palette = 11=#ffd156
palette = 12=#4d83d0
palette = 13=#ff55ff
palette = 14=#83e8e4
palette = 15=#ffffff
palette = 16=#fdc253
palette = 17=#762f33
palette = 18=#15171c
palette = 19=#555555
palette = 20=#a1a09e
palette = 21=#eeece7

# Foreground & background colors
background = #212121
foreground = #c7c6c2
cursor-color = #c7c6c2
selection-background = #c7c6c2
selection-foreground = #555555
search-background = #4d83d0
search-foreground = #15171c
search-selected-background = #fdc253
search-selected-foreground = #15171c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4d83d0
]==]

local me = assert(rex.call("server.whoami")).principal
if me.transport ~= "unix" then
    io.stderr:write("rex: not connected to a local Rex server, skipping\n")
    return
end

-- Rex names an imported theme after its file, and re-importing a name
-- replaces that theme's colors.
local home = os.getenv("HOME")
local dir = (os.getenv("XDG_CACHE_HOME") or (home .. "/.cache")) .. "/tinted-theming/rex"
rex.exec({ "mkdir", "-p", dir })
local file = dir .. "/" .. name
local out = assert(io.open(file, "w"))
out:write(theme)
out:close()

local function perform(client, action, args)
    local _, err = rex.call("client.perform", {
        client_id = client.client_id, action = action, args = args,
    })
    return err
end

-- Apps connected over the server's local socket as the same user are the
-- apps on this machine.
local list = assert(rex.call("client.list", { kinds = { "app" } }))
local failures = {}
for _, client in ipairs(list.clients or {}) do
    local peer = client.principal or {}
    local label = (client.info or {}).label or client.client_id
    if peer.transport == "unix" and peer.uid == me.uid then
        -- Rex guesses a theme's appearance from its colors when importing.
        -- Switch to the scheme's own variant in case it guessed wrong.
        local err = perform(client, "client.theme.import", { path = file })
            or perform(client, "client.appearance.switch_mode", { mode = variant })
        if err then
            table.insert(failures, label .. ": " .. tostring(err))
        end
    else
        io.stderr:write("rex: skipped " .. label .. ", which is connected from another machine or user\n")
    end
end

if #failures > 0 then
    error(table.concat(failures, "\n"))
end
