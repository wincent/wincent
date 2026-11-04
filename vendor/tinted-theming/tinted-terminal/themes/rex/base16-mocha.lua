-- vim: ft=lua
-- Mocha theme for Rex
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

local name = "base16-mocha"
local variant = "dark"

-- This must match themes/ghostty/base16-mocha exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Mocha theme for Ghostty
# Scheme Author: Chris Kempson (http://chriskempson.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#3b3228
palette = 1=#cb6077
palette = 2=#beb55b
palette = 3=#f4bc87
palette = 4=#8ab3b5
palette = 5=#a89bb9
palette = 6=#7bbda4
palette = 7=#d0c8c6
palette = 8=#7e705a
palette = 9=#cb6077
palette = 10=#beb55b
palette = 11=#f4bc87
palette = 12=#8ab3b5
palette = 13=#a89bb9
palette = 14=#7bbda4
palette = 15=#f5eeeb
palette = 16=#d28b71
palette = 17=#bb9584
palette = 18=#534636
palette = 19=#645240
palette = 20=#b8afad
palette = 21=#e9e1dd

# Foreground & background colors
background = #3b3228
foreground = #d0c8c6
cursor-color = #d0c8c6
selection-background = #d0c8c6
selection-foreground = #645240
search-background = #f4bc87
search-foreground = #534636
search-selected-background = #d28b71
search-selected-foreground = #534636

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f5eeeb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8ab3b5
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
