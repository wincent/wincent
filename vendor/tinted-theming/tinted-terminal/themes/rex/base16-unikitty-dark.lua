-- vim: ft=lua
-- Unikitty Dark theme for Rex
-- Scheme Author: Josh W Lewis (@joshwlewis)
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

local name = "base16-unikitty-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-unikitty-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Unikitty Dark theme for Ghostty
# Scheme Author: Josh W Lewis (@joshwlewis)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2e2a31
palette = 1=#d8137f
palette = 2=#17ad98
palette = 3=#dc8a0e
palette = 4=#796af5
palette = 5=#bb60ea
palette = 6=#149bda
palette = 7=#bcbabe
palette = 8=#838085
palette = 9=#d8137f
palette = 10=#17ad98
palette = 11=#dc8a0e
palette = 12=#796af5
palette = 13=#bb60ea
palette = 14=#149bda
palette = 15=#f5f4f7
palette = 16=#d65407
palette = 17=#c720ca
palette = 18=#4a464d
palette = 19=#666369
palette = 20=#9f9da2
palette = 21=#d8d7da

# Foreground & background colors
background = #2e2a31
foreground = #bcbabe
cursor-color = #bcbabe
selection-background = #bcbabe
selection-foreground = #666369
search-background = #dc8a0e
search-foreground = #4a464d
search-selected-background = #d65407
search-selected-foreground = #4a464d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f5f4f7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #796af5
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
