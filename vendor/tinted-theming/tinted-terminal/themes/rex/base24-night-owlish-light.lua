-- vim: ft=lua
-- Night Owlish Light theme for Rex
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

local name = "base24-night-owlish-light"
local variant = "light"

-- This must match themes/ghostty/base24-night-owlish-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Night Owlish Light theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#d3423e
palette = 2=#2aa298
palette = 3=#dac801
palette = 4=#4876d6
palette = 5=#403f53
palette = 6=#08916a
palette = 7=#585b5b
palette = 8=#b1b4b4
palette = 9=#f76e6e
palette = 10=#49d0c5
palette = 11=#dac26b
palette = 12=#5ca7e4
palette = 13=#697098
palette = 14=#00c990
palette = 15=#011627
palette = 16=#daaa01
palette = 17=#69211f
palette = 18=#e5e6e6
palette = 19=#cbcdcd
palette = 20=#717575
palette = 21=#3f4141

# Foreground & background colors
background = #ffffff
foreground = #585b5b
cursor-color = #585b5b
selection-background = #585b5b
selection-foreground = #cbcdcd
search-background = #dac801
search-foreground = #e5e6e6
search-selected-background = #daaa01
search-selected-foreground = #e5e6e6

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #011627
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5ca7e4
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
