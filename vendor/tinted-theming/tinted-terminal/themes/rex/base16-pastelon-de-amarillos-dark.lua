-- vim: ft=lua
-- Pastelón de Amarillos Dark theme for Rex
-- Scheme Author: Richard Martinez (https://sonofmartinus.com)
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

local name = "base16-pastelon-de-amarillos-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-pastelon-de-amarillos-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Pastelón de Amarillos Dark theme for Ghostty
# Scheme Author: Richard Martinez (https://sonofmartinus.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#180d18
palette = 1=#ff646a
palette = 2=#3ccb83
palette = 3=#ffc84a
palette = 4=#5a9fe6
palette = 5=#d978cf
palette = 6=#35c4b6
palette = 7=#ffe0a3
palette = 8=#a0747c
palette = 9=#ff646a
palette = 10=#3ccb83
palette = 11=#ffc84a
palette = 12=#5a9fe6
palette = 13=#d978cf
palette = 14=#35c4b6
palette = 15=#fff7e6
palette = 16=#f99a32
palette = 17=#e2764a
palette = 18=#2a1424
palette = 19=#432031
palette = 20=#c39a89
palette = 21=#ffebc5

# Foreground & background colors
background = #180d18
foreground = #ffe0a3
cursor-color = #ffe0a3
selection-background = #ffe0a3
selection-foreground = #432031
search-background = #ffc84a
search-foreground = #2a1424
search-selected-background = #f99a32
search-selected-foreground = #2a1424

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fff7e6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5a9fe6
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
