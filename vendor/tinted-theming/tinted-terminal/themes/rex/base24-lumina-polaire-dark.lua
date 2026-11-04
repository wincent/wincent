-- vim: ft=lua
-- Lumina Polaire Dark theme for Rex
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

local name = "base24-lumina-polaire-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-polaire-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Polaire Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0f1a21
palette = 1=#cd776f
palette = 2=#a9d6b1
palette = 3=#e2c682
palette = 4=#aeccf2
palette = 5=#bfbaf7
palette = 6=#8cd9f4
palette = 7=#d7e1e8
palette = 8=#25323b
palette = 9=#dc978f
palette = 10=#c2f1ca
palette = 11=#fde099
palette = 12=#d1e5ff
palette = 13=#ffd3fa
palette = 14=#c2efff
palette = 15=#d7e1e8
palette = 16=#f4c59d
palette = 17=#e6b8e1
palette = 18=#121f27
palette = 19=#1c2831
palette = 20=#5e6d77
palette = 21=#a9b3b9

# Foreground & background colors
background = #0f1a21
foreground = #d7e1e8
cursor-color = #d7e1e8
selection-background = #d7e1e8
selection-foreground = #1c2831
search-background = #e2c682
search-foreground = #121f27
search-selected-background = #f4c59d
search-selected-foreground = #121f27

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d7e1e8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #d1e5ff
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
