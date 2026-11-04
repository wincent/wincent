-- vim: ft=lua
-- Cyberdyne theme for Rex
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

local name = "base24-cyberdyne"
local variant = "dark"

-- This must match themes/ghostty/base24-cyberdyne exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Cyberdyne theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#151144
palette = 1=#ff8272
palette = 2=#00c172
palette = 3=#c1e3fe
palette = 4=#0071cf
palette = 5=#ff8ffd
palette = 6=#6bffdc
palette = 7=#c0c0c0
palette = 8=#5e5e5e
palette = 9=#ffc4bd
palette = 10=#d6fcb9
palette = 11=#fefdd5
palette = 12=#c1e3fe
palette = 13=#ffb1fe
palette = 14=#e5e6fe
palette = 15=#feffff
palette = 16=#d2a700
palette = 17=#7f4139
palette = 18=#080808
palette = 19=#2d2d2d
palette = 20=#8f8f8f
palette = 21=#f1f1f1

# Foreground & background colors
background = #151144
foreground = #c0c0c0
cursor-color = #c0c0c0
selection-background = #c0c0c0
selection-foreground = #2d2d2d
search-background = #c1e3fe
search-foreground = #080808
search-selected-background = #d2a700
search-selected-foreground = #080808

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #feffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #c1e3fe
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
