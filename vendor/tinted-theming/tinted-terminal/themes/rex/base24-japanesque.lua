-- vim: ft=lua
-- Japanesque theme for Rex
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

local name = "base24-japanesque"
local variant = "dark"

-- This must match themes/ghostty/base24-japanesque exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Japanesque theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1d1d1d
palette = 1=#ce3e60
palette = 2=#7bb75b
palette = 3=#135879
palette = 4=#4c99d3
palette = 5=#a57fc4
palette = 6=#389aac
palette = 7=#d0d2ce
palette = 8=#80827f
palette = 9=#d18ea6
palette = 10=#767e2b
palette = 11=#77592e
palette = 12=#135879
palette = 13=#5f4190
palette = 14=#76bbca
palette = 15=#b1b5ae
palette = 16=#e8b32a
palette = 17=#671f30
palette = 18=#343835
palette = 19=#585a58
palette = 20=#a8aaa7
palette = 21=#f9faf6

# Foreground & background colors
background = #1d1d1d
foreground = #d0d2ce
cursor-color = #d0d2ce
selection-background = #d0d2ce
selection-foreground = #585a58
search-background = #135879
search-foreground = #343835
search-selected-background = #e8b32a
search-selected-foreground = #343835

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #b1b5ae
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #135879
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
