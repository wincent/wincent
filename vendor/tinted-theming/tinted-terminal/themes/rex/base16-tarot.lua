-- vim: ft=lua
-- tarot theme for Rex
-- Scheme Author: ed (https://codeberg.org/ed)
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

local name = "base16-tarot"
local variant = "dark"

-- This must match themes/ghostty/base16-tarot exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# tarot theme for Ghostty
# Scheme Author: ed (https://codeberg.org/ed)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0e091d
palette = 1=#c53253
palette = 2=#a68e5a
palette = 3=#ff6565
palette = 4=#6e6080
palette = 5=#a45782
palette = 6=#8c9785
palette = 7=#aa556f
palette = 8=#74316b
palette = 9=#c53253
palette = 10=#a68e5a
palette = 11=#ff6565
palette = 12=#6e6080
palette = 13=#a45782
palette = 14=#8c9785
palette = 15=#dc8f7c
palette = 16=#ea4d60
palette = 17=#984d51
palette = 18=#2a153c
palette = 19=#4b2054
palette = 20=#8c406f
palette = 21=#c4686d

# Foreground & background colors
background = #0e091d
foreground = #aa556f
cursor-color = #aa556f
selection-background = #aa556f
selection-foreground = #4b2054
search-background = #ff6565
search-foreground = #2a153c
search-selected-background = #ea4d60
search-selected-foreground = #2a153c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #dc8f7c
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6e6080
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
