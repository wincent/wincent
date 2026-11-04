-- vim: ft=lua
-- Spaceduck theme for Rex
-- Scheme Author: Guillermo Rodriguez (https://github.com/pineapplegiant), packaged by Gabriel Fontes (https://github.com/Misterio77)
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

local name = "base16-spaceduck"
local variant = "dark"

-- This must match themes/ghostty/base16-spaceduck exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Spaceduck theme for Ghostty
# Scheme Author: Guillermo Rodriguez (https://github.com/pineapplegiant), packaged by Gabriel Fontes (https://github.com/Misterio77)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#16172d
palette = 1=#e33400
palette = 2=#5ccc96
palette = 3=#f2ce00
palette = 4=#7a5ccc
palette = 5=#b3a1e6
palette = 6=#00a3cc
palette = 7=#ecf0c1
palette = 8=#686f9a
palette = 9=#e33400
palette = 10=#5ccc96
palette = 11=#f2ce00
palette = 12=#7a5ccc
palette = 13=#b3a1e6
palette = 14=#00a3cc
palette = 15=#ffffff
palette = 16=#e39400
palette = 17=#ce6f8f
palette = 18=#1b1c36
palette = 19=#30365f
palette = 20=#818596
palette = 21=#c1c3cc

# Foreground & background colors
background = #16172d
foreground = #ecf0c1
cursor-color = #ecf0c1
selection-background = #ecf0c1
selection-foreground = #30365f
search-background = #f2ce00
search-foreground = #1b1c36
search-selected-background = #e39400
search-selected-foreground = #1b1c36

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7a5ccc
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
