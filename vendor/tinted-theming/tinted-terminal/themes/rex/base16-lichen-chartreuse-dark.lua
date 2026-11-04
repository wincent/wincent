-- vim: ft=lua
-- Lichen Chartreuse Dark theme for Rex
-- Scheme Author: Aaron Colichia (https://aaron.colichia.org/)
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

local name = "base16-lichen-chartreuse-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-lichen-chartreuse-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lichen Chartreuse Dark theme for Ghostty
# Scheme Author: Aaron Colichia (https://aaron.colichia.org/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#151613
palette = 1=#e28b82
palette = 2=#83bda5
palette = 3=#b2d084
palette = 4=#78adc4
palette = 5=#bfa6d4
palette = 6=#9cc6c9
palette = 7=#e0e5da
palette = 8=#899282
palette = 9=#e28b82
palette = 10=#83bda5
palette = 11=#b2d084
palette = 12=#78adc4
palette = 13=#bfa6d4
palette = 14=#9cc6c9
palette = 15=#fcfcfa
palette = 16=#d5ad73
palette = 17=#d2a0b2
palette = 18=#1c1e1a
palette = 19=#3e5123
palette = 20=#a0a598
palette = 21=#ecefe7

# Foreground & background colors
background = #151613
foreground = #e0e5da
cursor-color = #e0e5da
selection-background = #e0e5da
selection-foreground = #3e5123
search-background = #b2d084
search-foreground = #1c1e1a
search-selected-background = #d5ad73
search-selected-foreground = #1c1e1a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fcfcfa
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #78adc4
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
