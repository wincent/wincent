-- vim: ft=lua
-- Serendipity Midnight theme for Rex
-- Scheme Author: Micheal Andreuzza (https://michaelandreuzza.com/)
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

local name = "base16-serendipity-midnight"
local variant = "dark"

-- This must match themes/ghostty/base16-serendipity-midnight exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Serendipity Midnight theme for Ghostty
# Scheme Author: Micheal Andreuzza (https://michaelandreuzza.com/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#151726
palette = 1=#ee8679
palette = 2=#5ba2d0
palette = 3=#a78bfa
palette = 4=#94b8ff
palette = 5=#a78bfa
palette = 6=#f8d2c9
palette = 7=#dee0ef
palette = 8=#6b6d7c
palette = 9=#ee8679
palette = 10=#5ba2d0
palette = 11=#a78bfa
palette = 12=#94b8ff
palette = 13=#a78bfa
palette = 14=#f8d2c9
palette = 15=#151726
palette = 16=#ee8679
palette = 17=#5ba2d0
palette = 18=#1c1e2d
palette = 19=#1c1e2d
palette = 20=#8d8f9e
palette = 21=#dee0ef

# Foreground & background colors
background = #151726
foreground = #dee0ef
cursor-color = #dee0ef
selection-background = #dee0ef
selection-foreground = #1c1e2d
search-background = #a78bfa
search-foreground = #1c1e2d
search-selected-background = #ee8679
search-selected-foreground = #1c1e2d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #151726
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #94b8ff
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
