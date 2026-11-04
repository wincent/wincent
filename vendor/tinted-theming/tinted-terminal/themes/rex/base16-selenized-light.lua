-- vim: ft=lua
-- selenized-light theme for Rex
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

local name = "base16-selenized-light"
local variant = "light"

-- This must match themes/ghostty/base16-selenized-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# selenized-light theme for Ghostty
# Scheme Author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fbf3db
palette = 1=#cc1729
palette = 2=#428b00
palette = 3=#a78300
palette = 4=#006dce
palette = 5=#825dc0
palette = 6=#00978a
palette = 7=#53676d
palette = 8=#909995
palette = 9=#cc1729
palette = 10=#428b00
palette = 11=#a78300
palette = 12=#006dce
palette = 13=#825dc0
palette = 14=#00978a
palette = 15=#3a4d53
palette = 16=#bc5819
palette = 17=#c44392
palette = 18=#ece3cc
palette = 19=#d5cdb6
palette = 20=#909995
palette = 21=#3a4d53

# Foreground & background colors
background = #fbf3db
foreground = #53676d
cursor-color = #53676d
selection-background = #53676d
selection-foreground = #d5cdb6
search-background = #a78300
search-foreground = #3a4d53
search-selected-background = #bc5819
search-selected-foreground = #3a4d53

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #3a4d53
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #006dce
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
