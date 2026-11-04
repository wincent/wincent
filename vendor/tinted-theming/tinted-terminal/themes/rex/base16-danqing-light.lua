-- vim: ft=lua
-- DanQing Light theme for Rex
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

local name = "base16-danqing-light"
local variant = "light"

-- This must match themes/ghostty/base16-danqing-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# DanQing Light theme for Ghostty
# Scheme Author: Wenhan Zhu (Cosmos) (zhuwenhan950913@gmail.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fcfefd
palette = 1=#f9906f
palette = 2=#8ab361
palette = 3=#f0c239
palette = 4=#b0a4e3
palette = 5=#cca4e3
palette = 6=#30dff3
palette = 7=#5a605d
palette = 8=#cad8d2
palette = 9=#f9906f
palette = 10=#8ab361
palette = 11=#f0c239
palette = 12=#b0a4e3
palette = 13=#cca4e3
palette = 14=#30dff3
palette = 15=#2d302f
palette = 16=#b38a61
palette = 17=#ca6924
palette = 18=#ecf6f2
palette = 19=#e0f0ef
palette = 20=#9da8a3
palette = 21=#434846

# Foreground & background colors
background = #fcfefd
foreground = #5a605d
cursor-color = #5a605d
selection-background = #5a605d
selection-foreground = #e0f0ef
search-background = #f0c239
search-foreground = #2d302f
search-selected-background = #b38a61
search-selected-foreground = #2d302f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #2d302f
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
