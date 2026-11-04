-- vim: ft=lua
-- Cobalt Neon theme for Rex
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

local name = "base24-cobalt-neon"
local variant = "dark"

-- This must match themes/ghostty/base24-cobalt-neon exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Cobalt Neon theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#142838
palette = 1=#ff2320
palette = 2=#3aa5ff
palette = 3=#3c7dd2
palette = 4=#8ff586
palette = 5=#781aa0
palette = 6=#8ff586
palette = 7=#cc72a6
palette = 8=#eeca92
palette = 9=#d4312e
palette = 10=#8ff586
palette = 11=#e9f06d
palette = 12=#3c7dd2
palette = 13=#8230a7
palette = 14=#6cbc67
palette = 15=#8ff586
palette = 16=#e9e75c
palette = 17=#7f1110
palette = 18=#142630
palette = 19=#fff688
palette = 20=#dd9e9c
palette = 21=#ba45b1

# Foreground & background colors
background = #142838
foreground = #cc72a6
cursor-color = #cc72a6
selection-background = #cc72a6
selection-foreground = #fff688
search-background = #3c7dd2
search-foreground = #142630
search-selected-background = #e9e75c
search-selected-foreground = #142630

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #8ff586
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3c7dd2
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
