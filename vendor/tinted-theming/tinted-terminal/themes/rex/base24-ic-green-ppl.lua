-- vim: ft=lua
-- IC-Green-PPL theme for Rex
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

local name = "base24-ic-green-ppl"
local variant = "dark"

-- This must match themes/ghostty/base24-ic-green-ppl exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# IC-Green-PPL theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2c2c2c
palette = 1=#fe2635
palette = 2=#41a638
palette = 3=#2efaeb
palette = 4=#2ec3b9
palette = 5=#50a096
palette = 6=#3ca078
palette = 7=#add5b6
palette = 8=#3b843e
palette = 9=#b4fa5c
palette = 10=#aefa86
palette = 11=#dafa87
palette = 12=#2efaeb
palette = 13=#50fafa
palette = 14=#3cfac8
palette = 15=#e0f1dc
palette = 16=#76a830
palette = 17=#7f131a
palette = 18=#014401
palette = 19=#025c02
palette = 20=#74ad7a
palette = 21=#e6fef2

# Foreground & background colors
background = #2c2c2c
foreground = #add5b6
cursor-color = #add5b6
selection-background = #add5b6
selection-foreground = #025c02
search-background = #2efaeb
search-foreground = #014401
search-selected-background = #76a830
search-selected-foreground = #014401

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e0f1dc
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #2efaeb
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
