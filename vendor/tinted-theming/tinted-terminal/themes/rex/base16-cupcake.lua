-- vim: ft=lua
-- Cupcake theme for Rex
-- Scheme Author: Chris Kempson (http://chriskempson.com)
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

local name = "base16-cupcake"
local variant = "light"

-- This must match themes/ghostty/base16-cupcake exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Cupcake theme for Ghostty
# Scheme Author: Chris Kempson (http://chriskempson.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fbf1f2
palette = 1=#d57e85
palette = 2=#a3b367
palette = 3=#dcb16c
palette = 4=#7297b9
palette = 5=#bb99b4
palette = 6=#69a9a7
palette = 7=#8b8198
palette = 8=#bfb9c6
palette = 9=#d57e85
palette = 10=#a3b367
palette = 11=#dcb16c
palette = 12=#7297b9
palette = 13=#bb99b4
palette = 14=#69a9a7
palette = 15=#585062
palette = 16=#ebb790
palette = 17=#baa58c
palette = 18=#f2f1f4
palette = 19=#d8d5dd
palette = 20=#a59daf
palette = 21=#72677e

# Foreground & background colors
background = #fbf1f2
foreground = #8b8198
cursor-color = #8b8198
selection-background = #8b8198
selection-foreground = #d8d5dd
search-background = #dcb16c
search-foreground = #585062
search-selected-background = #ebb790
search-selected-foreground = #585062

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #585062
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7297b9
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
