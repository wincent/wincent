-- vim: ft=lua
-- Material theme for Rex
-- Scheme Author: Nate Peterson
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

local name = "base16-material"
local variant = "dark"

-- This must match themes/ghostty/base16-material exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Material theme for Ghostty
# Scheme Author: Nate Peterson
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#263238
palette = 1=#f07178
palette = 2=#c3e88d
palette = 3=#ffcb6b
palette = 4=#82aaff
palette = 5=#c792ea
palette = 6=#89ddff
palette = 7=#eeffff
palette = 8=#546e7a
palette = 9=#f07178
palette = 10=#c3e88d
palette = 11=#ffcb6b
palette = 12=#82aaff
palette = 13=#c792ea
palette = 14=#89ddff
palette = 15=#ffffff
palette = 16=#f78c6c
palette = 17=#ff5370
palette = 18=#2e3c43
palette = 19=#314549
palette = 20=#b2ccd6
palette = 21=#eeffff

# Foreground & background colors
background = #263238
foreground = #eeffff
cursor-color = #eeffff
selection-background = #eeffff
selection-foreground = #314549
search-background = #ffcb6b
search-foreground = #2e3c43
search-selected-background = #f78c6c
search-selected-foreground = #2e3c43

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #82aaff
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
