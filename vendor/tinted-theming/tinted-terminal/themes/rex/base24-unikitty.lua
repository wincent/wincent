-- vim: ft=lua
-- Unikitty theme for Rex
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

local name = "base24-unikitty"
local variant = "light"

-- This must match themes/ghostty/base24-unikitty exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Unikitty theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ff7ad3
palette = 1=#a80f20
palette = 2=#bafc8b
palette = 3=#eedf4b
palette = 4=#145fcd
palette = 5=#ff36a2
palette = 6=#6bd0bc
palette = 7=#b9b1b8
palette = 8=#696769
palette = 9=#d81329
palette = 10=#d2ffaf
palette = 11=#ffee50
palette = 12=#0074ea
palette = 13=#fdd5e5
palette = 14=#79ebd5
palette = 15=#fff2fd
palette = 16=#eeaa4b
palette = 17=#540710
palette = 18=#0c0c0c
palette = 19=#424242
palette = 20=#918c91
palette = 21=#e1d6e0

# Foreground & background colors
background = #ff7ad3
foreground = #b9b1b8
cursor-color = #b9b1b8
selection-background = #b9b1b8
selection-foreground = #424242
search-background = #eedf4b
search-foreground = #0c0c0c
search-selected-background = #eeaa4b
search-selected-foreground = #0c0c0c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fff2fd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0074ea
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
