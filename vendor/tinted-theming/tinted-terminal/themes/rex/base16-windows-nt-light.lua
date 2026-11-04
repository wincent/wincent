-- vim: ft=lua
-- Windows NT Light theme for Rex
-- Scheme Author: Fergus Collins (https://github.com/ferguscollins)
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

local name = "base16-windows-nt-light"
local variant = "light"

-- This must match themes/ghostty/base16-windows-nt-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Windows NT Light theme for Ghostty
# Scheme Author: Fergus Collins (https://github.com/ferguscollins)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#800000
palette = 2=#008000
palette = 3=#808000
palette = 4=#000080
palette = 5=#800080
palette = 6=#008080
palette = 7=#808080
palette = 8=#c0c0c0
palette = 9=#800000
palette = 10=#008000
palette = 11=#808000
palette = 12=#000080
palette = 13=#800080
palette = 14=#008080
palette = 15=#000000
palette = 16=#ffff00
palette = 17=#00ff00
palette = 18=#eaeaea
palette = 19=#d5d5d5
palette = 20=#a0a0a0
palette = 21=#404040

# Foreground & background colors
background = #ffffff
foreground = #808080
cursor-color = #808080
selection-background = #808080
selection-foreground = #d5d5d5
search-background = #808000
search-foreground = #000000
search-selected-background = #ffff00
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #000000
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #000080
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
