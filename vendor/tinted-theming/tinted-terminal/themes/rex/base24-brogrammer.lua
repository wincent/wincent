-- vim: ft=lua
-- Brogrammer theme for Rex
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

local name = "base24-brogrammer"
local variant = "dark"

-- This must match themes/ghostty/base24-brogrammer exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Brogrammer theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#131313
palette = 1=#f71118
palette = 2=#2cc55d
palette = 3=#0f80d5
palette = 4=#2a84d2
palette = 5=#4e59b7
palette = 6=#0f80d5
palette = 7=#c1c8d7
palette = 8=#343d50
palette = 9=#de342e
palette = 10=#1dd260
palette = 11=#f2bd09
palette = 12=#509bdc
palette = 13=#524fb9
palette = 14=#289af0
palette = 15=#ffffff
palette = 16=#ecb90f
palette = 17=#7b080c
palette = 18=#1f1f1f
palette = 19=#2a3141
palette = 20=#d6dae4
palette = 21=#e3e6ed

# Foreground & background colors
background = #131313
foreground = #c1c8d7
cursor-color = #c1c8d7
selection-background = #c1c8d7
selection-foreground = #2a3141
search-background = #0f80d5
search-foreground = #1f1f1f
search-selected-background = #ecb90f
search-selected-foreground = #1f1f1f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #509bdc
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
