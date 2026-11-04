-- vim: ft=lua
-- selenized-black theme for Rex
-- Scheme Author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
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

local name = "base16-selenized-black"
local variant = "dark"

-- This must match themes/ghostty/base16-selenized-black exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# selenized-black theme for Ghostty
# Scheme Author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#181818
palette = 1=#ed4a46
palette = 2=#70b433
palette = 3=#dbb32d
palette = 4=#368aeb
palette = 5=#a580e2
palette = 6=#3fc5b7
palette = 7=#b9b9b9
palette = 8=#777777
palette = 9=#ed4a46
palette = 10=#70b433
palette = 11=#dbb32d
palette = 12=#368aeb
palette = 13=#a580e2
palette = 14=#3fc5b7
palette = 15=#dedede
palette = 16=#e67f43
palette = 17=#eb6eb7
palette = 18=#252525
palette = 19=#3b3b3b
palette = 20=#777777
palette = 21=#dedede

# Foreground & background colors
background = #181818
foreground = #b9b9b9
cursor-color = #b9b9b9
selection-background = #b9b9b9
selection-foreground = #3b3b3b
search-background = #dbb32d
search-foreground = #252525
search-selected-background = #e67f43
search-selected-foreground = #252525

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #dedede
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #368aeb
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
