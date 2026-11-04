-- vim: ft=lua
-- Synth Midnight Terminal Light theme for Rex
-- Scheme Author: Michaël Ball (http://github.com/michael-ball/)
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

local name = "base16-synth-midnight-light"
local variant = "light"

-- This must match themes/ghostty/base16-synth-midnight-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Synth Midnight Terminal Light theme for Ghostty
# Scheme Author: Michaël Ball (http://github.com/michael-ball/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#dddfe0
palette = 1=#b53b50
palette = 2=#06ea61
palette = 3=#c9d364
palette = 4=#03aeff
palette = 5=#ea5ce2
palette = 6=#42fff9
palette = 7=#28292a
palette = 8=#a3a5a6
palette = 9=#b53b50
palette = 10=#06ea61
palette = 11=#c9d364
palette = 12=#03aeff
palette = 13=#ea5ce2
palette = 14=#42fff9
palette = 15=#050608
palette = 16=#ea770d
palette = 17=#cd6320
palette = 18=#cfd1d2
palette = 19=#c1c3c4
palette = 20=#474849
palette = 21=#1a1b1c

# Foreground & background colors
background = #dddfe0
foreground = #28292a
cursor-color = #28292a
selection-background = #28292a
selection-foreground = #c1c3c4
search-background = #c9d364
search-foreground = #050608
search-selected-background = #ea770d
search-selected-foreground = #050608

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #050608
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #03aeff
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
