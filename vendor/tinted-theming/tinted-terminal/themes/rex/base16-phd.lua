-- vim: ft=lua
-- PhD theme for Rex
-- Scheme Author: Hennig Hasemann (http://leetless.de/vim.html)
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

local name = "base16-phd"
local variant = "dark"

-- This must match themes/ghostty/base16-phd exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# PhD theme for Ghostty
# Scheme Author: Hennig Hasemann (http://leetless.de/vim.html)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#061229
palette = 1=#d07346
palette = 2=#99bf52
palette = 3=#fbd461
palette = 4=#5299bf
palette = 5=#9989cc
palette = 6=#72b9bf
palette = 7=#b8bbc2
palette = 8=#717885
palette = 9=#d07346
palette = 10=#99bf52
palette = 11=#fbd461
palette = 12=#5299bf
palette = 13=#9989cc
palette = 14=#72b9bf
palette = 15=#ffffff
palette = 16=#f0a000
palette = 17=#b08060
palette = 18=#2a3448
palette = 19=#4d5666
palette = 20=#9a99a3
palette = 21=#dbdde0

# Foreground & background colors
background = #061229
foreground = #b8bbc2
cursor-color = #b8bbc2
selection-background = #b8bbc2
selection-foreground = #4d5666
search-background = #fbd461
search-foreground = #2a3448
search-selected-background = #f0a000
search-selected-foreground = #2a3448

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5299bf
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
