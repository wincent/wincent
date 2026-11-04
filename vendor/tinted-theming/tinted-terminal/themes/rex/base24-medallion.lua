-- vim: ft=lua
-- Medallion theme for Rex
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

local name = "base24-medallion"
local variant = "dark"

-- This must match themes/ghostty/base24-medallion exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Medallion theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1d1808
palette = 1=#b54c00
palette = 2=#7c8a16
palette = 3=#abb8ff
palette = 4=#606baf
palette = 5=#8b5990
palette = 6=#906b25
palette = 7=#aea578
palette = 8=#786d38
palette = 9=#ff9148
palette = 10=#b1c93a
palette = 11=#ffe449
palette = 12=#abb8ff
palette = 13=#fe9fff
palette = 14=#ffbb51
palette = 15=#fed597
palette = 16=#d2bd25
palette = 17=#5a2600
palette = 18=#000000
palette = 19=#5e5118
palette = 20=#938958
palette = 21=#c9c199

# Foreground & background colors
background = #1d1808
foreground = #aea578
cursor-color = #aea578
selection-background = #aea578
selection-foreground = #5e5118
search-background = #abb8ff
search-foreground = #000000
search-selected-background = #d2bd25
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fed597
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #abb8ff
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
