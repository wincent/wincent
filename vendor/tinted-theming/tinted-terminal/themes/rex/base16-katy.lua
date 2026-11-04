-- vim: ft=lua
-- Katy theme for Rex
-- Scheme Author: George Essig (https://github.com/gessig)
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

local name = "base16-katy"
local variant = "dark"

-- This must match themes/ghostty/base16-katy exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Katy theme for Ghostty
# Scheme Author: George Essig (https://github.com/gessig)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#292d3e
palette = 1=#6e98e1
palette = 2=#78c06e
palette = 3=#e0a557
palette = 4=#82aaff
palette = 5=#c792ea
palette = 6=#83b7e5
palette = 7=#959dcb
palette = 8=#676e95
palette = 9=#6e98e1
palette = 10=#78c06e
palette = 11=#e0a557
palette = 12=#82aaff
palette = 13=#c792ea
palette = 14=#83b7e5
palette = 15=#ffffff
palette = 16=#f78c6c
palette = 17=#ff5370
palette = 18=#444267
palette = 19=#5c598b
palette = 20=#8796b0
palette = 21=#959dcb

# Foreground & background colors
background = #292d3e
foreground = #959dcb
cursor-color = #959dcb
selection-background = #959dcb
selection-foreground = #5c598b
search-background = #e0a557
search-foreground = #444267
search-selected-background = #f78c6c
search-selected-foreground = #444267

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #82aaff
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
