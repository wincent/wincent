-- vim: ft=lua
-- DanQing theme for Rex
-- Scheme Author: Wenhan Zhu (Cosmos) (zhuwenhan950913@gmail.com)
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

local name = "base16-danqing"
local variant = "dark"

-- This must match themes/ghostty/base16-danqing exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# DanQing theme for Ghostty
# Scheme Author: Wenhan Zhu (Cosmos) (zhuwenhan950913@gmail.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2d302f
palette = 1=#f9906f
palette = 2=#8ab361
palette = 3=#f0c239
palette = 4=#b0a4e3
palette = 5=#cca4e3
palette = 6=#30dff3
palette = 7=#e0f0ef
palette = 8=#9da8a3
palette = 9=#f9906f
palette = 10=#8ab361
palette = 11=#f0c239
palette = 12=#b0a4e3
palette = 13=#cca4e3
palette = 14=#30dff3
palette = 15=#fcfefd
palette = 16=#b38a61
palette = 17=#ca6924
palette = 18=#434846
palette = 19=#5a605d
palette = 20=#cad8d2
palette = 21=#ecf6f2

# Foreground & background colors
background = #2d302f
foreground = #e0f0ef
cursor-color = #e0f0ef
selection-background = #e0f0ef
selection-foreground = #5a605d
search-background = #f0c239
search-foreground = #434846
search-selected-background = #b38a61
search-selected-foreground = #434846

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fcfefd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b0a4e3
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
