-- vim: ft=lua
-- Lumina Dusk Dark theme for Rex
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

local name = "base24-lumina-dusk-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-dusk-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Dusk Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1a1825
palette = 1=#d0746c
palette = 2=#a0d1a9
palette = 3=#efcb7b
palette = 4=#9bbef2
palette = 5=#c1bbf0
palette = 6=#90cfd7
palette = 7=#e0dcea
palette = 8=#323040
palette = 9=#de958d
palette = 10=#b9ecc2
palette = 11=#ffe5ad
palette = 12=#bdd8ff
palette = 13=#fcc9f7
palette = 14=#a9e9f2
palette = 15=#e0dcea
palette = 16=#f5b284
palette = 17=#e1b0dc
palette = 18=#1f1c2b
palette = 19=#282635
palette = 20=#6d697d
palette = 21=#b1afbc

# Foreground & background colors
background = #1a1825
foreground = #e0dcea
cursor-color = #e0dcea
selection-background = #e0dcea
selection-foreground = #282635
search-background = #efcb7b
search-foreground = #1f1c2b
search-selected-background = #f5b284
search-selected-foreground = #1f1c2b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e0dcea
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #bdd8ff
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
