-- vim: ft=lua
-- Mountain theme for Rex
-- Scheme Author: Stefan Weigl-Bosker (https://github.com/sweiglbosker), based on Mountain Theme (https://github.com/mountain-theme/Mountain)
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

local name = "base24-mountain"
local variant = "dark"

-- This must match themes/ghostty/base24-mountain exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Mountain theme for Ghostty
# Scheme Author: Stefan Weigl-Bosker (https://github.com/sweiglbosker), based on Mountain Theme (https://github.com/mountain-theme/Mountain)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0f0f0f
palette = 1=#ac8a8c
palette = 2=#8aac8b
palette = 3=#aca98a
palette = 4=#8f8aac
palette = 5=#ac8aac
palette = 6=#8aabac
palette = 7=#cacaca
palette = 8=#393939
palette = 9=#c49ea0
palette = 10=#9ec49f
palette = 11=#c4c19e
palette = 12=#a39ec4
palette = 13=#c49ec4
palette = 14=#9ec3c4
palette = 15=#f0f0f0
palette = 16=#c6a679
palette = 17=#ac8a8c
palette = 18=#191919
palette = 19=#262626
palette = 20=#4c4c4c
palette = 21=#e7e7e7

# Foreground & background colors
background = #0f0f0f
foreground = #cacaca
cursor-color = #cacaca
selection-background = #cacaca
selection-foreground = #262626
search-background = #aca98a
search-foreground = #191919
search-selected-background = #c6a679
search-selected-foreground = #191919

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f0f0f0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a39ec4
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
