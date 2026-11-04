-- vim: ft=lua
-- Twilight theme for Rex
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

local name = "base24-twilight"
local variant = "dark"

-- This must match themes/ghostty/base24-twilight exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Twilight theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#141414
palette = 1=#c06c43
palette = 2=#afb979
palette = 3=#5a5d61
palette = 4=#444649
palette = 5=#b4be7b
palette = 6=#778284
palette = 7=#c8c8a7
palette = 8=#5c5c51
palette = 9=#dd7c4c
palette = 10=#cbd88c
palette = 11=#e1c47d
palette = 12=#5a5d61
palette = 13=#d0db8e
palette = 14=#8a989a
palette = 15=#feffd3
palette = 16=#c2a86c
palette = 17=#603621
palette = 18=#141414
palette = 19=#262626
palette = 20=#92927c
palette = 21=#feffd3

# Foreground & background colors
background = #141414
foreground = #c8c8a7
cursor-color = #c8c8a7
selection-background = #c8c8a7
selection-foreground = #262626
search-background = #5a5d61
search-foreground = #141414
search-selected-background = #c2a86c
search-selected-foreground = #141414

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #feffd3
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5a5d61
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
