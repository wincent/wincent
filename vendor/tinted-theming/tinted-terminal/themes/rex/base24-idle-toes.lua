-- vim: ft=lua
-- Idle Toes theme for Rex
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

local name = "base24-idle-toes"
local variant = "dark"

-- This must match themes/ghostty/base24-idle-toes exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Idle Toes theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#323232
palette = 1=#d25252
palette = 2=#7fe173
palette = 3=#5eb7f7
palette = 4=#4098ff
palette = 5=#f57fff
palette = 6=#bed6ff
palette = 7=#c7c7c5
palette = 8=#797979
palette = 9=#f07070
palette = 10=#9dff90
palette = 11=#ffe48b
palette = 12=#5eb7f7
palette = 13=#ff9dff
palette = 14=#dcf4ff
palette = 15=#ffffff
palette = 16=#ffc66d
palette = 17=#692929
palette = 18=#323232
palette = 19=#535353
palette = 20=#a0a09f
palette = 21=#eeeeec

# Foreground & background colors
background = #323232
foreground = #c7c7c5
cursor-color = #c7c7c5
selection-background = #c7c7c5
selection-foreground = #535353
search-background = #5eb7f7
search-foreground = #323232
search-selected-background = #ffc66d
search-selected-foreground = #323232

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5eb7f7
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
