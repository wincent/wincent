-- vim: ft=lua
-- Elemental theme for Rex
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

local name = "base24-elemental"
local variant = "dark"

-- This must match themes/ghostty/base24-elemental exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Elemental theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#21211c
palette = 1=#97280f
palette = 2=#479942
palette = 3=#78d8d8
palette = 4=#497f7d
palette = 5=#7e4e2e
palette = 6=#387f58
palette = 7=#756f68
palette = 8=#5f5d50
palette = 9=#df502a
palette = 10=#60e06f
palette = 11=#d69827
palette = 12=#78d8d8
palette = 13=#cd7c53
palette = 14=#58d598
palette = 15=#fff1e8
palette = 16=#7f7110
palette = 17=#4b1407
palette = 18=#3c3b30
palette = 19=#545444
palette = 20=#6a665c
palette = 21=#807974

# Foreground & background colors
background = #21211c
foreground = #756f68
cursor-color = #756f68
selection-background = #756f68
selection-foreground = #545444
search-background = #78d8d8
search-foreground = #3c3b30
search-selected-background = #7f7110
search-selected-foreground = #3c3b30

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fff1e8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #78d8d8
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
