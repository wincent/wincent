-- vim: ft=lua
-- OceanicNext theme for Rex
-- Scheme Author: https://github.com/voronianski/oceanic-next-color-scheme
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

local name = "base16-oceanicnext"
local variant = "dark"

-- This must match themes/ghostty/base16-oceanicnext exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# OceanicNext theme for Ghostty
# Scheme Author: https://github.com/voronianski/oceanic-next-color-scheme
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1b2b34
palette = 1=#ec5f67
palette = 2=#99c794
palette = 3=#fac863
palette = 4=#6699cc
palette = 5=#c594c5
palette = 6=#5fb3b3
palette = 7=#c0c5ce
palette = 8=#65737e
palette = 9=#ec5f67
palette = 10=#99c794
palette = 11=#fac863
palette = 12=#6699cc
palette = 13=#c594c5
palette = 14=#5fb3b3
palette = 15=#d8dee9
palette = 16=#f99157
palette = 17=#ab7967
palette = 18=#343d46
palette = 19=#4f5b66
palette = 20=#a7adba
palette = 21=#cdd3de

# Foreground & background colors
background = #1b2b34
foreground = #c0c5ce
cursor-color = #c0c5ce
selection-background = #c0c5ce
selection-foreground = #4f5b66
search-background = #fac863
search-foreground = #343d46
search-selected-background = #f99157
search-selected-foreground = #343d46

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d8dee9
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6699cc
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
