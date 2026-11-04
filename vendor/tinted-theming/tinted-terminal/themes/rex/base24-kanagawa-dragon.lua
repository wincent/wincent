-- vim: ft=lua
-- Kanagawa Dragon theme for Rex
-- Scheme Author: Stefan Weigl-Bosker (https://github.com/sweiglbosker), Tommaso Laurenzi (https://github.com/rebelot/kanagawa.nvim)
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

local name = "base24-kanagawa-dragon"
local variant = "dark"

-- This must match themes/ghostty/base24-kanagawa-dragon exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Kanagawa Dragon theme for Ghostty
# Scheme Author: Stefan Weigl-Bosker (https://github.com/sweiglbosker), Tommaso Laurenzi (https://github.com/rebelot/kanagawa.nvim)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#181616
palette = 1=#c4746e
palette = 2=#8a9a7b
palette = 3=#c4b28a
palette = 4=#8ba4b0
palette = 5=#a292a3
palette = 6=#8ea4a2
palette = 7=#c5c9c5
palette = 8=#625e5a
palette = 9=#e46876
palette = 10=#87a987
palette = 11=#e6c384
palette = 12=#7fb4ca
palette = 13=#938aa9
palette = 14=#7aa89f
palette = 15=#c5c9c5
palette = 16=#b6927b
palette = 17=#b98d7b
palette = 18=#282727
palette = 19=#393836
palette = 20=#737c73
palette = 21=#c8c093

# Foreground & background colors
background = #181616
foreground = #c5c9c5
cursor-color = #c5c9c5
selection-background = #c5c9c5
selection-foreground = #393836
search-background = #c4b28a
search-foreground = #282727
search-selected-background = #b6927b
search-selected-foreground = #282727

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #c5c9c5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7fb4ca
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
