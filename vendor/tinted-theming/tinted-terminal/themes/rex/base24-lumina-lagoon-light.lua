-- vim: ft=lua
-- Lumina Lagoon Light theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
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

local name = "base24-lumina-lagoon-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-lagoon-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Lagoon Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#e9fafa
palette = 1=#8f2121
palette = 2=#2e6147
palette = 3=#a1600d
palette = 4=#185ca9
palette = 5=#7153b5
palette = 6=#006e71
palette = 7=#0b323b
palette = 8=#c5d8d8
palette = 9=#682220
palette = 10=#005031
palette = 11=#874e00
palette = 12=#154986
palette = 13=#72366e
palette = 14=#00585b
palette = 15=#0b323b
palette = 16=#924918
palette = 17=#894984
palette = 18=#e1f4f4
palette = 19=#d5e8e8
palette = 20=#758b8b
palette = 21=#384c4c

# Foreground & background colors
background = #e9fafa
foreground = #0b323b
cursor-color = #0b323b
selection-background = #0b323b
selection-foreground = #d5e8e8
search-background = #a1600d
search-foreground = #e1f4f4
search-selected-background = #924918
search-selected-foreground = #e1f4f4

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #0b323b
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #154986
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
