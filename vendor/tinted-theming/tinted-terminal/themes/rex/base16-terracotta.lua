-- vim: ft=lua
-- Terracotta theme for Rex
-- Scheme Author: Alexander Rossell Hayes (https://github.com/rossellhayes)
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

local name = "base16-terracotta"
local variant = "light"

-- This must match themes/ghostty/base16-terracotta exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Terracotta theme for Ghostty
# Scheme Author: Alexander Rossell Hayes (https://github.com/rossellhayes)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#efeae8
palette = 1=#a75045
palette = 2=#7a894a
palette = 3=#ce943e
palette = 4=#625574
palette = 5=#8d5968
palette = 6=#847f9e
palette = 7=#473731
palette = 8=#c0aca4
palette = 9=#a75045
palette = 10=#7a894a
palette = 11=#ce943e
palette = 12=#625574
palette = 13=#8d5968
palette = 14=#847f9e
palette = 15=#241c19
palette = 16=#bd6942
palette = 17=#b07158
palette = 18=#dfd6d1
palette = 19=#d0c1bb
palette = 20=#59453d
palette = 21=#352a25

# Foreground & background colors
background = #efeae8
foreground = #473731
cursor-color = #473731
selection-background = #473731
selection-foreground = #d0c1bb
search-background = #ce943e
search-foreground = #241c19
search-selected-background = #bd6942
search-selected-foreground = #241c19

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #241c19
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #625574
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
