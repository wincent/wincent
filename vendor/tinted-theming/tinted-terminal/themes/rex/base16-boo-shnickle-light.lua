-- vim: ft=lua
-- boo-shnickle-light theme for Rex
-- Scheme Author: boo-shnickle (@boo_shnickle)
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

local name = "base16-boo-shnickle-light"
local variant = "light"

-- This must match themes/ghostty/base16-boo-shnickle-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# boo-shnickle-light theme for Ghostty
# Scheme Author: boo-shnickle (@boo_shnickle)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffcc
palette = 1=#ffbfa5
palette = 2=#e7ff99
palette = 3=#fff299
palette = 4=#bfbfd9
palette = 5=#f2bfd9
palette = 6=#bfffc5
palette = 7=#5b5b49
palette = 8=#9c9c7d
palette = 9=#ffbfa5
palette = 10=#e7ff99
palette = 11=#fff299
palette = 12=#bfbfd9
palette = 13=#f2bfd9
palette = 14=#bfffc5
palette = 15=#191914
palette = 16=#ffdc99
palette = 17=#e5d6a6
palette = 18=#dedeb2
palette = 19=#bdbd97
palette = 20=#7c7c63
palette = 21=#3a3a2e

# Foreground & background colors
background = #ffffcc
foreground = #5b5b49
cursor-color = #5b5b49
selection-background = #5b5b49
selection-foreground = #bdbd97
search-background = #fff299
search-foreground = #191914
search-selected-background = #ffdc99
search-selected-foreground = #191914

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #191914
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #bfbfd9
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
