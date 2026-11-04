-- vim: ft=lua
-- Grape theme for Rex
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

local name = "base24-grape"
local variant = "dark"

-- This must match themes/ghostty/base24-grape exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Grape theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#161423
palette = 1=#ec2160
palette = 2=#1fa91b
palette = 3=#a9bbeb
palette = 4=#487cf4
palette = 5=#8c35c8
palette = 6=#3added
palette = 7=#8c8a92
palette = 8=#696377
palette = 9=#f0719a
palette = 10=#52a95d
palette = 11=#b2dc87
palette = 12=#a9bbeb
palette = 13=#ac81c1
palette = 14=#9ce3ea
palette = 15=#a188f7
palette = 16=#8ddc1f
palette = 17=#761030
palette = 18=#2d283e
palette = 19=#58506a
palette = 20=#7b7785
palette = 21=#9e9ea0

# Foreground & background colors
background = #161423
foreground = #8c8a92
cursor-color = #8c8a92
selection-background = #8c8a92
selection-foreground = #58506a
search-background = #a9bbeb
search-foreground = #2d283e
search-selected-background = #8ddc1f
search-selected-foreground = #2d283e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #a188f7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a9bbeb
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
