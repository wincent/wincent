-- vim: ft=lua
-- Hopscotch theme for Rex
-- Scheme Author: Jan T. Sott
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

local name = "base16-hopscotch"
local variant = "dark"

-- This must match themes/ghostty/base16-hopscotch exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Hopscotch theme for Ghostty
# Scheme Author: Jan T. Sott
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#322931
palette = 1=#dd464c
palette = 2=#8fc13e
palette = 3=#fdcc59
palette = 4=#1290bf
palette = 5=#c85e7c
palette = 6=#149b93
palette = 7=#b9b5b8
palette = 8=#797379
palette = 9=#dd464c
palette = 10=#8fc13e
palette = 11=#fdcc59
palette = 12=#1290bf
palette = 13=#c85e7c
palette = 14=#149b93
palette = 15=#ffffff
palette = 16=#fd8b19
palette = 17=#b33508
palette = 18=#433b42
palette = 19=#5c545b
palette = 20=#989498
palette = 21=#d5d3d5

# Foreground & background colors
background = #322931
foreground = #b9b5b8
cursor-color = #b9b5b8
selection-background = #b9b5b8
selection-foreground = #5c545b
search-background = #fdcc59
search-foreground = #433b42
search-selected-background = #fd8b19
search-selected-foreground = #433b42

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1290bf
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
