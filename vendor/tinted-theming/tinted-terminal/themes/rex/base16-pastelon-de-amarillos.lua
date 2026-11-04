-- vim: ft=lua
-- Pastelón de Amarillos theme for Rex
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

local name = "base16-pastelon-de-amarillos"
local variant = "light"

-- This must match themes/ghostty/base16-pastelon-de-amarillos exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Pastelón de Amarillos theme for Ghostty
# Scheme Author: Richard Martinez (https://sonofmartinus.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fff4d6
palette = 1=#bd3548
palette = 2=#167451
palette = 3=#946400
palette = 4=#1e5da8
palette = 5=#8d3f89
palette = 6=#007270
palette = 7=#432c3b
palette = 8=#80616b
palette = 9=#bd3548
palette = 10=#167451
palette = 11=#946400
palette = 12=#1e5da8
palette = 13=#8d3f89
palette = 14=#007270
palette = 15=#1c0f20
palette = 16=#ad570f
palette = 17=#7c3528
palette = 18=#f2d083
palette = 19=#d69b45
palette = 20=#684653
palette = 21=#2f1c2e

# Foreground & background colors
background = #fff4d6
foreground = #432c3b
cursor-color = #432c3b
selection-background = #432c3b
selection-foreground = #d69b45
search-background = #946400
search-foreground = #1c0f20
search-selected-background = #ad570f
search-selected-foreground = #1c0f20

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1c0f20
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1e5da8
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
