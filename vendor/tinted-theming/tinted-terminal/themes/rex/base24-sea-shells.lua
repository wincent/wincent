-- vim: ft=lua
-- Sea Shells theme for Rex
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

local name = "base24-sea-shells"
local variant = "dark"

-- This must match themes/ghostty/base24-sea-shells exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Sea Shells theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#08131a
palette = 1=#d15023
palette = 2=#027c9b
palette = 3=#1bbcdd
palette = 4=#1e4950
palette = 5=#68d3f1
palette = 6=#50a3b5
palette = 7=#b79c7e
palette = 8=#696660
palette = 9=#d38677
palette = 10=#618c98
palette = 11=#fdd29e
palette = 12=#1bbcdd
palette = 13=#bbe3ee
palette = 14=#86abb3
palette = 15=#fee3cd
palette = 16=#fca02f
palette = 17=#682811
palette = 18=#17384c
palette = 19=#424b52
palette = 20=#90816f
palette = 21=#deb88d

# Foreground & background colors
background = #08131a
foreground = #b79c7e
cursor-color = #b79c7e
selection-background = #b79c7e
selection-foreground = #424b52
search-background = #1bbcdd
search-foreground = #17384c
search-selected-background = #fca02f
search-selected-foreground = #17384c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fee3cd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1bbcdd
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
