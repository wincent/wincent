-- vim: ft=lua
-- PaperColor Dark theme for Rex
-- Scheme Author: Jon Leopard (http://github.com/jonleopard), Tinted Theming (https://github.com/tinted-theming), based on PaperColor Theme (https://github.com/NLKNguyen/papercolor-theme)
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

local name = "base16-papercolor-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-papercolor-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# PaperColor Dark theme for Ghostty
# Scheme Author: Jon Leopard (http://github.com/jonleopard), Tinted Theming (https://github.com/tinted-theming), based on PaperColor Theme (https://github.com/NLKNguyen/papercolor-theme)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c1c1c
palette = 1=#ff5faf
palette = 2=#5faf5f
palette = 3=#ffaf00
palette = 4=#5fafd7
palette = 5=#af87d7
palette = 6=#00afaf
palette = 7=#9e9e9e
palette = 8=#585858
palette = 9=#ff5faf
palette = 10=#5faf5f
palette = 11=#ffaf00
palette = 12=#5fafd7
palette = 13=#af87d7
palette = 14=#00afaf
palette = 15=#d0d0d0
palette = 16=#d7af5f
palette = 17=#af005f
palette = 18=#363636
palette = 19=#424242
palette = 20=#808080
palette = 21=#b8b8b8

# Foreground & background colors
background = #1c1c1c
foreground = #9e9e9e
cursor-color = #9e9e9e
selection-background = #9e9e9e
selection-foreground = #424242
search-background = #ffaf00
search-foreground = #363636
search-selected-background = #d7af5f
search-selected-foreground = #363636

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d0d0d0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5fafd7
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
