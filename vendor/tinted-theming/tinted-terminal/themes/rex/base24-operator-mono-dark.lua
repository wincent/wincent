-- vim: ft=lua
-- Operator Mono Dark theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-operator-mono-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-operator-mono-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Operator Mono Dark theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#191919
palette = 1=#ca372d
palette = 2=#4d7b3a
palette = 3=#89d3f6
palette = 4=#4387cf
palette = 5=#b86cb4
palette = 6=#72d4c6
palette = 7=#c0c4c0
palette = 8=#a6a8a6
palette = 9=#c37d62
palette = 10=#83d0a2
palette = 11=#fdfdc5
palette = 12=#89d3f6
palette = 13=#fe2c79
palette = 14=#82e9da
palette = 15=#fdfdf6
palette = 16=#d4d697
palette = 17=#651b16
palette = 18=#5a5a5a
palette = 19=#9a9a99
palette = 20=#b3b6b3
palette = 21=#cdd3cd

# Foreground & background colors
background = #191919
foreground = #c0c4c0
cursor-color = #c0c4c0
selection-background = #c0c4c0
selection-foreground = #9a9a99
search-background = #89d3f6
search-foreground = #5a5a5a
search-selected-background = #d4d697
search-selected-foreground = #5a5a5a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fdfdf6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #89d3f6
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
