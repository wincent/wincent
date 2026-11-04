-- vim: ft=lua
-- Tango theme for Rex
-- Scheme Author: @Schnouki, based on the Tango Desktop Project
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

local name = "base16-tango"
local variant = "dark"

-- This must match themes/ghostty/base16-tango exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tango theme for Ghostty
# Scheme Author: @Schnouki, based on the Tango Desktop Project
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2e3436
palette = 1=#cc0000
palette = 2=#4e9a06
palette = 3=#c4a000
palette = 4=#3465a4
palette = 5=#75507b
palette = 6=#06989a
palette = 7=#d3d7cf
palette = 8=#555753
palette = 9=#cc0000
palette = 10=#4e9a06
palette = 11=#c4a000
palette = 12=#3465a4
palette = 13=#75507b
palette = 14=#06989a
palette = 15=#eeeeec
palette = 16=#ef2929
palette = 17=#34e2e2
palette = 18=#8ae234
palette = 19=#fce94f
palette = 20=#729fcf
palette = 21=#ad7fa8

# Foreground & background colors
background = #2e3436
foreground = #d3d7cf
cursor-color = #d3d7cf
selection-background = #d3d7cf
selection-foreground = #fce94f
search-background = #c4a000
search-foreground = #8ae234
search-selected-background = #ef2929
search-selected-foreground = #8ae234

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #eeeeec
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3465a4
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
