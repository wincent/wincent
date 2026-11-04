-- vim: ft=lua
-- Aftertaerm theme for Rex
-- Scheme Author: Radek Polasek (https://github.com/radekp31), based on Taerminal by cozywigwam
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

local name = "base16-ataerm"
local variant = "dark"

-- This must match themes/ghostty/base16-ataerm exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Aftertaerm theme for Ghostty
# Scheme Author: Radek Polasek (https://github.com/radekp31), based on Taerminal by cozywigwam
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#26282a
palette = 1=#ff8878
palette = 2=#b4fb73
palette = 3=#fffcb7
palette = 4=#8bbce5
palette = 5=#ffb2fe
palette = 6=#a2e1f8
palette = 7=#f0f0f0
palette = 8=#6f6f6f
palette = 9=#ff8878
palette = 10=#b4fb73
palette = 11=#fffcb7
palette = 12=#8bbce5
palette = 13=#ffb2fe
palette = 14=#a2e1f8
palette = 15=#ffffff
palette = 16=#ffb88a
palette = 17=#d69a8a
palette = 18=#303234
palette = 19=#3c3e41
palette = 20=#a8a8a8
palette = 21=#f1f1f1

# Foreground & background colors
background = #26282a
foreground = #f0f0f0
cursor-color = #f0f0f0
selection-background = #f0f0f0
selection-foreground = #3c3e41
search-background = #fffcb7
search-foreground = #303234
search-selected-background = #ffb88a
search-selected-foreground = #303234

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8bbce5
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
