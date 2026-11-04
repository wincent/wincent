-- vim: ft=lua
-- Batman theme for Rex
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

local name = "base24-batman"
local variant = "dark"

-- This must match themes/ghostty/base24-batman exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Batman theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1b1d1e
palette = 1=#e6db43
palette = 2=#c8be46
palette = 3=#909495
palette = 4=#737074
palette = 5=#737271
palette = 6=#615f5e
palette = 7=#a7a8a3
palette = 8=#6d6f6e
palette = 9=#fff68d
palette = 10=#fff27c
palette = 11=#feed6c
palette = 12=#909495
palette = 13=#9a999d
palette = 14=#a2a2a5
palette = 15=#dadad5
palette = 16=#f3fd21
palette = 17=#736d21
palette = 18=#1b1d1e
palette = 19=#505354
palette = 20=#8a8c89
palette = 21=#c5c5be

# Foreground & background colors
background = #1b1d1e
foreground = #a7a8a3
cursor-color = #a7a8a3
selection-background = #a7a8a3
selection-foreground = #505354
search-background = #909495
search-foreground = #1b1d1e
search-selected-background = #f3fd21
search-selected-foreground = #1b1d1e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #dadad5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #909495
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
