-- vim: ft=lua
-- Mezcal theme for Rex
-- Scheme Author: Teshre
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

local name = "base16-mezcal"
local variant = "dark"

-- This must match themes/ghostty/base16-mezcal exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Mezcal theme for Ghostty
# Scheme Author: Teshre
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#13110e
palette = 1=#da6e54
palette = 2=#a8b84a
palette = 3=#d9a441
palette = 4=#8aa6c0
palette = 5=#c28aa8
palette = 6=#6fc8ae
palette = 7=#e0d8c8
palette = 8=#6e6450
palette = 9=#da6e54
palette = 10=#a8b84a
palette = 11=#d9a441
palette = 12=#8aa6c0
palette = 13=#c28aa8
palette = 14=#6fc8ae
palette = 15=#f2ead6
palette = 16=#d9a441
palette = 17=#4e462c
palette = 18=#221f14
palette = 19=#36301e
palette = 20=#a79e8c
palette = 21=#e9e1cf

# Foreground & background colors
background = #13110e
foreground = #e0d8c8
cursor-color = #e0d8c8
selection-background = #e0d8c8
selection-foreground = #36301e
search-background = #d9a441
search-foreground = #221f14
search-selected-background = #d9a441
search-selected-foreground = #221f14

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f2ead6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8aa6c0
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
