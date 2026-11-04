-- vim: ft=lua
-- Kimber theme for Rex
-- Scheme Author: Mishka Nguyen (https://github.com/akhsiM)
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

local name = "base16-kimber"
local variant = "dark"

-- This must match themes/ghostty/base16-kimber exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Kimber theme for Ghostty
# Scheme Author: Mishka Nguyen (https://github.com/akhsiM)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#222222
palette = 1=#c88c8c
palette = 2=#99c899
palette = 3=#d8b56d
palette = 4=#537c9c
palette = 5=#86cacd
palette = 6=#78b4b4
palette = 7=#dedee7
palette = 8=#644646
palette = 9=#c88c8c
palette = 10=#99c899
palette = 11=#d8b56d
palette = 12=#537c9c
palette = 13=#86cacd
palette = 14=#78b4b4
palette = 15=#ffffe6
palette = 16=#476c88
palette = 17=#704f4f
palette = 18=#313131
palette = 19=#555d55
palette = 20=#5a5a5a
palette = 21=#c3c3b4

# Foreground & background colors
background = #222222
foreground = #dedee7
cursor-color = #dedee7
selection-background = #dedee7
selection-foreground = #555d55
search-background = #d8b56d
search-foreground = #313131
search-selected-background = #476c88
search-selected-foreground = #313131

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffe6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #537c9c
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
