-- vim: ft=lua
-- Laser theme for Rex
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

local name = "base24-laser"
local variant = "dark"

-- This must match themes/ghostty/base24-laser exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Laser theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#030d18
palette = 1=#ff8272
palette = 2=#b4fa72
palette = 3=#f92883
palette = 4=#fed300
palette = 5=#ff8ffd
palette = 6=#d0d1fe
palette = 7=#d8d8d8
palette = 8=#a6a6a6
palette = 9=#ffc4bd
palette = 10=#d6fcb9
palette = 11=#fefdd5
palette = 12=#f92883
palette = 13=#ffb1fe
palette = 14=#e5e6fe
palette = 15=#feffff
palette = 16=#09b4bd
palette = 17=#7f4139
palette = 18=#616161
palette = 19=#8e8e8e
palette = 20=#bfbfbf
palette = 21=#f1f1f1

# Foreground & background colors
background = #030d18
foreground = #d8d8d8
cursor-color = #d8d8d8
selection-background = #d8d8d8
selection-foreground = #8e8e8e
search-background = #f92883
search-foreground = #616161
search-selected-background = #09b4bd
search-selected-foreground = #616161

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #feffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #f92883
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
