-- vim: ft=lua
-- Shaman theme for Rex
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

local name = "base24-shaman"
local variant = "dark"

-- This must match themes/ghostty/base24-shaman exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Shaman theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#001014
palette = 1=#b12f2c
palette = 2=#00a940
palette = 3=#61d4b9
palette = 4=#449985
palette = 5=#00599c
palette = 6=#5c7e19
palette = 7=#3d5053
palette = 8=#394751
palette = 9=#ff4242
palette = 10=#2aea5e
palette = 11=#8dd3fd
palette = 12=#61d4b9
palette = 13=#1298ff
palette = 14=#98cf28
palette = 15=#58fad6
palette = 16=#5d8aa9
palette = 17=#581716
palette = 18=#012026
palette = 19=#374350
palette = 20=#3b4c52
palette = 21=#405554

# Foreground & background colors
background = #001014
foreground = #3d5053
cursor-color = #3d5053
selection-background = #3d5053
selection-foreground = #374350
search-background = #61d4b9
search-foreground = #012026
search-selected-background = #5d8aa9
search-selected-foreground = #012026

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #58fad6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #61d4b9
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
