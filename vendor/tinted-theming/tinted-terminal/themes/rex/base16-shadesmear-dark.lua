-- vim: ft=lua
-- ShadeSmear Dark theme for Rex
-- Scheme Author: Kyle Giammarco (http://kyle.giammar.co)
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

local name = "base16-shadesmear-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-shadesmear-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# ShadeSmear Dark theme for Ghostty
# Scheme Author: Kyle Giammarco (http://kyle.giammar.co)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#232323
palette = 1=#cc5450
palette = 2=#71983b
palette = 3=#307878
palette = 4=#376388
palette = 5=#d7ab54
palette = 6=#c57d42
palette = 7=#dbdbdb
palette = 8=#c0c0c0
palette = 9=#cc5450
palette = 10=#71983b
palette = 11=#307878
palette = 12=#376388
palette = 13=#d7ab54
palette = 14=#c57d42
palette = 15=#1c1c1c
palette = 16=#a64270
palette = 17=#6d6d6d
palette = 18=#1c1c1c
palette = 19=#4e4e4e
palette = 20=#e4e4e4
palette = 21=#e4e4e4

# Foreground & background colors
background = #232323
foreground = #dbdbdb
cursor-color = #dbdbdb
selection-background = #dbdbdb
selection-foreground = #4e4e4e
search-background = #307878
search-foreground = #1c1c1c
search-selected-background = #a64270
search-selected-foreground = #1c1c1c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1c1c1c
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #376388
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
