-- vim: ft=lua
-- Warm Neon theme for Rex
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

local name = "base24-warm-neon"
local variant = "dark"

-- This must match themes/ghostty/base24-warm-neon exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Warm Neon theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#3f3f3f
palette = 1=#e24345
palette = 2=#38b139
palette = 3=#7a90d5
palette = 4=#4260c5
palette = 5=#f81ffb
palette = 6=#29bad3
palette = 7=#dcc9ba
palette = 8=#f2ebe6
palette = 9=#e86f71
palette = 10=#9bc08f
palette = 11=#ddd979
palette = 12=#7a90d5
palette = 13=#f674b9
palette = 14=#5ed1e4
palette = 15=#d8c8bb
palette = 16=#dae145
palette = 17=#712122
palette = 18=#000000
palette = 19=#fdfcfc
palette = 20=#e7dad0
palette = 21=#d0b8a3

# Foreground & background colors
background = #3f3f3f
foreground = #dcc9ba
cursor-color = #dcc9ba
selection-background = #dcc9ba
selection-foreground = #fdfcfc
search-background = #7a90d5
search-foreground = #000000
search-selected-background = #dae145
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d8c8bb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7a90d5
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
