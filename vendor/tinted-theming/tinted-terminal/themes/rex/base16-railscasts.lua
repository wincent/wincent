-- vim: ft=lua
-- Railscasts theme for Rex
-- Scheme Author: Ryan Bates (http://railscasts.com)
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

local name = "base16-railscasts"
local variant = "dark"

-- This must match themes/ghostty/base16-railscasts exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Railscasts theme for Ghostty
# Scheme Author: Ryan Bates (http://railscasts.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2b2b2b
palette = 1=#da4939
palette = 2=#a5c261
palette = 3=#ffc66d
palette = 4=#6d9cbe
palette = 5=#b6b3eb
palette = 6=#519f50
palette = 7=#e6e1dc
palette = 8=#5a647e
palette = 9=#da4939
palette = 10=#a5c261
palette = 11=#ffc66d
palette = 12=#6d9cbe
palette = 13=#b6b3eb
palette = 14=#519f50
palette = 15=#f9f7f3
palette = 16=#cc7833
palette = 17=#bc9458
palette = 18=#272935
palette = 19=#3a4055
palette = 20=#d4cfc9
palette = 21=#f4f1ed

# Foreground & background colors
background = #2b2b2b
foreground = #e6e1dc
cursor-color = #e6e1dc
selection-background = #e6e1dc
selection-foreground = #3a4055
search-background = #ffc66d
search-foreground = #272935
search-selected-background = #cc7833
search-selected-foreground = #272935

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f9f7f3
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6d9cbe
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
