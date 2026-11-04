-- vim: ft=lua
-- Materia theme for Rex
-- Scheme Author: Defman21
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

local name = "base16-materia"
local variant = "dark"

-- This must match themes/ghostty/base16-materia exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Materia theme for Ghostty
# Scheme Author: Defman21
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#263238
palette = 1=#ec5f67
palette = 2=#8bd649
palette = 3=#ffcc00
palette = 4=#89ddff
palette = 5=#82aaff
palette = 6=#80cbc4
palette = 7=#cdd3de
palette = 8=#707880
palette = 9=#ec5f67
palette = 10=#8bd649
palette = 11=#ffcc00
palette = 12=#89ddff
palette = 13=#82aaff
palette = 14=#80cbc4
palette = 15=#ffffff
palette = 16=#ea9560
palette = 17=#ec5f67
palette = 18=#2c393f
palette = 19=#37474f
palette = 20=#c9ccd3
palette = 21=#d5dbe5

# Foreground & background colors
background = #263238
foreground = #cdd3de
cursor-color = #cdd3de
selection-background = #cdd3de
selection-foreground = #37474f
search-background = #ffcc00
search-foreground = #2c393f
search-selected-background = #ea9560
search-selected-foreground = #2c393f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #89ddff
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
