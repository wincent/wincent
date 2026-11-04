-- vim: ft=lua
-- Moonlight theme for Rex
-- Scheme Author: Jeremy Swinarton (https://github.com/jswinarton)
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

local name = "base16-moonlight"
local variant = "dark"

-- This must match themes/ghostty/base16-moonlight exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Moonlight theme for Ghostty
# Scheme Author: Jeremy Swinarton (https://github.com/jswinarton)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#212337
palette = 1=#ff5370
palette = 2=#2df4c0
palette = 3=#ffc777
palette = 4=#40ffff
palette = 5=#b994f1
palette = 6=#04d1f9
palette = 7=#a3ace1
palette = 8=#748cd6
palette = 9=#ff5370
palette = 10=#2df4c0
palette = 11=#ffc777
palette = 12=#40ffff
palette = 13=#b994f1
palette = 14=#04d1f9
palette = 15=#ef43fa
palette = 16=#f67f81
palette = 17=#ecb2f0
palette = 18=#403c64
palette = 19=#596399
palette = 20=#a1abe0
palette = 21=#b4a4f4

# Foreground & background colors
background = #212337
foreground = #a3ace1
cursor-color = #a3ace1
selection-background = #a3ace1
selection-foreground = #596399
search-background = #ffc777
search-foreground = #403c64
search-selected-background = #f67f81
search-selected-foreground = #403c64

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ef43fa
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #40ffff
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
