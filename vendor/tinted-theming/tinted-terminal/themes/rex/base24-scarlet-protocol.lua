-- vim: ft=lua
-- Scarlet Protocol theme for Rex
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

local name = "base24-scarlet-protocol"
local variant = "dark"

-- This must match themes/ghostty/base24-scarlet-protocol exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Scarlet Protocol theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1b153c
palette = 1=#ff0051
palette = 2=#00dc84
palette = 3=#6871ff
palette = 4=#0271b6
palette = 5=#c930c7
palette = 6=#00c5c7
palette = 7=#afafaf
palette = 8=#7f7f7f
palette = 9=#ff6d67
palette = 10=#5ff967
palette = 11=#fefb67
palette = 12=#6871ff
palette = 13=#bc35eb
palette = 14=#5ffdff
palette = 15=#feffff
palette = 16=#faf945
palette = 17=#7f0028
palette = 18=#101116
palette = 19=#676767
palette = 20=#979797
palette = 21=#c7c7c7

# Foreground & background colors
background = #1b153c
foreground = #afafaf
cursor-color = #afafaf
selection-background = #afafaf
selection-foreground = #676767
search-background = #6871ff
search-foreground = #101116
search-selected-background = #faf945
search-selected-foreground = #101116

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #feffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6871ff
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
