-- vim: ft=lua
-- Sagelight theme for Rex
-- Scheme Author: Carter Veldhuizen
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

local name = "base16-sagelight"
local variant = "light"

-- This must match themes/ghostty/base16-sagelight exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Sagelight theme for Ghostty
# Scheme Author: Carter Veldhuizen
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f8f8f8
palette = 1=#fa8480
palette = 2=#a0d2c8
palette = 3=#ffdc61
palette = 4=#a0a7d2
palette = 5=#c8a0d2
palette = 6=#a2d6f5
palette = 7=#383838
palette = 8=#b8b8b8
palette = 9=#fa8480
palette = 10=#a0d2c8
palette = 11=#ffdc61
palette = 12=#a0a7d2
palette = 13=#c8a0d2
palette = 14=#a2d6f5
palette = 15=#181818
palette = 16=#ffaa61
palette = 17=#d2b2a0
palette = 18=#e8e8e8
palette = 19=#d8d8d8
palette = 20=#585858
palette = 21=#282828

# Foreground & background colors
background = #f8f8f8
foreground = #383838
cursor-color = #383838
selection-background = #383838
selection-foreground = #d8d8d8
search-background = #ffdc61
search-foreground = #181818
search-selected-background = #ffaa61
search-selected-foreground = #181818

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #181818
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a0a7d2
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
