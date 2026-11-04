-- vim: ft=lua
-- Lumina Ember Light theme for Rex
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

local name = "base24-lumina-ember-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-ember-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Ember Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f9f4ea
palette = 1=#811d1d
palette = 2=#437329
palette = 3=#a06116
palette = 4=#256b99
palette = 5=#6559a1
palette = 6=#007285
palette = 7=#372b1e
palette = 8=#d8d1c4
palette = 9=#5c1d1b
palette = 10=#355d20
palette = 11=#874e01
palette = 12=#005785
palette = 13=#783763
palette = 14=#005c6c
palette = 15=#372b1e
palette = 16=#864315
palette = 17=#96437b
palette = 18=#f4eddf
palette = 19=#e9e2d4
palette = 20=#8c8579
palette = 21=#4d473c

# Foreground & background colors
background = #f9f4ea
foreground = #372b1e
cursor-color = #372b1e
selection-background = #372b1e
selection-foreground = #e9e2d4
search-background = #a06116
search-foreground = #f4eddf
search-selected-background = #864315
search-selected-foreground = #f4eddf

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #372b1e
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #005785
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
