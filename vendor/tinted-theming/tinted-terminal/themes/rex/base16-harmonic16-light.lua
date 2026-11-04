-- vim: ft=lua
-- Harmonic16 Light theme for Rex
-- Scheme Author: Jannik Siebert (https://github.com/janniks)
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

local name = "base16-harmonic16-light"
local variant = "light"

-- This must match themes/ghostty/base16-harmonic16-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Harmonic16 Light theme for Ghostty
# Scheme Author: Jannik Siebert (https://github.com/janniks)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f7f9fb
palette = 1=#bf8b56
palette = 2=#56bf8b
palette = 3=#8bbf56
palette = 4=#8b56bf
palette = 5=#bf568b
palette = 6=#568bbf
palette = 7=#405c79
palette = 8=#aabcce
palette = 9=#bf8b56
palette = 10=#56bf8b
palette = 11=#8bbf56
palette = 12=#8b56bf
palette = 13=#bf568b
palette = 14=#568bbf
palette = 15=#0b1c2c
palette = 16=#bfbf56
palette = 17=#bf5656
palette = 18=#e5ebf1
palette = 19=#cbd6e2
palette = 20=#627e99
palette = 21=#223b54

# Foreground & background colors
background = #f7f9fb
foreground = #405c79
cursor-color = #405c79
selection-background = #405c79
selection-foreground = #cbd6e2
search-background = #8bbf56
search-foreground = #0b1c2c
search-selected-background = #bfbf56
search-selected-foreground = #0b1c2c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #0b1c2c
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8b56bf
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
