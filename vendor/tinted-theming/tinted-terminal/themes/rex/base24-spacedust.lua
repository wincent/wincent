-- vim: ft=lua
-- Spacedust theme for Rex
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

local name = "base24-spacedust"
local variant = "dark"

-- This must match themes/ghostty/base24-spacedust exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Spacedust theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0a1e24
palette = 1=#e35a00
palette = 2=#5cab96
palette = 3=#67a0cd
palette = 4=#0e548b
palette = 5=#e35a00
palette = 6=#06afc7
palette = 7=#cdc7a6
palette = 8=#897558
palette = 9=#ff8a39
palette = 10=#adcab8
palette = 11=#ffc777
palette = 12=#67a0cd
palette = 13=#ff8a39
palette = 14=#83a6b3
palette = 15=#fefff0
palette = 16=#e3cd7b
palette = 17=#712d00
palette = 18=#6e5246
palette = 19=#674c31
palette = 20=#ab9e7f
palette = 21=#f0f1ce

# Foreground & background colors
background = #0a1e24
foreground = #cdc7a6
cursor-color = #cdc7a6
selection-background = #cdc7a6
selection-foreground = #674c31
search-background = #67a0cd
search-foreground = #6e5246
search-selected-background = #e3cd7b
search-selected-foreground = #6e5246

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fefff0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #67a0cd
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
