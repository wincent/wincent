-- vim: ft=lua
-- Helsinki theme for Rex
-- Scheme Author: xscriptor (https://github.com/xscriptor)
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

local name = "base24-helsinki"
local variant = "light"

-- This must match themes/ghostty/base24-helsinki exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Helsinki theme for Ghostty
# Scheme Author: xscriptor (https://github.com/xscriptor)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f8fafe
palette = 1=#1faa9e
palette = 2=#733d9a
palette = 3=#2e70ad
palette = 4=#b55a0f
palette = 5=#3e9d21
palette = 6=#bd4c3d
palette = 7=#544d40
palette = 8=#b0a999
palette = 9=#009e91
palette = 10=#5a1f8a
palette = 11=#0f5ba2
palette = 12=#b23b00
palette = 13=#218c00
palette = 14=#b32e1f
palette = 15=#000000
palette = 16=#268da6
palette = 17=#1b6374
palette = 18=#edeef1
palette = 19=#e4e5e7
palette = 20=#8d8a82
palette = 21=#3b362d

# Foreground & background colors
background = #f8fafe
foreground = #544d40
cursor-color = #544d40
selection-background = #544d40
selection-foreground = #e4e5e7
search-background = #2e70ad
search-foreground = #edeef1
search-selected-background = #268da6
search-selected-foreground = #edeef1

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #000000
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b23b00
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
