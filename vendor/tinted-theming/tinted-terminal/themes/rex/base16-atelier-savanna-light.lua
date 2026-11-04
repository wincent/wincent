-- vim: ft=lua
-- Atelier Savanna Light theme for Rex
-- Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
-- Scheme System: base16
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

local name = "base16-atelier-savanna-light"
local variant = "light"

-- This must match themes/ghostty/base16-atelier-savanna-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Savanna Light theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ecf4ee
palette = 1=#b16139
palette = 2=#489963
palette = 3=#a07e3b
palette = 4=#478c90
palette = 5=#55859b
palette = 6=#1c9aa0
palette = 7=#526057
palette = 8=#78877d
palette = 9=#b16139
palette = 10=#489963
palette = 11=#a07e3b
palette = 12=#478c90
palette = 13=#55859b
palette = 14=#1c9aa0
palette = 15=#171c19
palette = 16=#9f713c
palette = 17=#867469
palette = 18=#dfe7e2
palette = 19=#87928a
palette = 20=#5f6d64
palette = 21=#232a25

# Foreground & background colors
background = #ecf4ee
foreground = #526057
cursor-color = #526057
selection-background = #526057
selection-foreground = #87928a
search-background = #a07e3b
search-foreground = #171c19
search-selected-background = #9f713c
search-selected-foreground = #171c19

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #171c19
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #478c90
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
