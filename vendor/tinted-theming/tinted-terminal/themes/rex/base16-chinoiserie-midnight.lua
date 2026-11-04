-- vim: ft=lua
-- Chinoiserie Midnight theme for Rex
-- Scheme Author: Di Wang (https://cs.cmu.edu/~diw3)
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

local name = "base16-chinoiserie-midnight"
local variant = "dark"

-- This must match themes/ghostty/base16-chinoiserie-midnight exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Chinoiserie Midnight theme for Ghostty
# Scheme Author: Di Wang (https://cs.cmu.edu/~diw3)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1d1d1d
palette = 1=#ed5a56
palette = 2=#aeb831
palette = 3=#fbb957
palette = 4=#81a2a2
palette = 5=#cf8997
palette = 6=#88b68d
palette = 7=#c4cbcf
palette = 8=#918072
palette = 9=#ed5a56
palette = 10=#aeb831
palette = 11=#fbb957
palette = 12=#81a2a2
palette = 13=#cf8997
palette = 14=#88b68d
palette = 15=#fffef9
palette = 16=#fc8c23
palette = 17=#cd6227
palette = 18=#282828
palette = 19=#373737
palette = 20=#bdaead
palette = 21=#eee7f2

# Foreground & background colors
background = #1d1d1d
foreground = #c4cbcf
cursor-color = #c4cbcf
selection-background = #c4cbcf
selection-foreground = #373737
search-background = #fbb957
search-foreground = #282828
search-selected-background = #fc8c23
search-selected-foreground = #282828

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fffef9
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #81a2a2
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
