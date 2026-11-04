-- vim: ft=lua
-- Catppuccin Macchiato theme for Rex
-- Scheme Author: https://github.com/catppuccin/catppuccin
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

local name = "base24-catppuccin-macchiato"
local variant = "dark"

-- This must match themes/ghostty/base24-catppuccin-macchiato exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Catppuccin Macchiato theme for Ghostty
# Scheme Author: https://github.com/catppuccin/catppuccin
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#24273a
palette = 1=#ed8796
palette = 2=#a6da95
palette = 3=#eed49f
palette = 4=#8aadf4
palette = 5=#c6a0f6
palette = 6=#8bd5ca
palette = 7=#cad3f5
palette = 8=#494d64
palette = 9=#ee99a0
palette = 10=#a6da95
palette = 11=#f4dbd6
palette = 12=#7dc4e4
palette = 13=#f5bde6
palette = 14=#91d7e3
palette = 15=#b7bdf8
palette = 16=#f5a97f
palette = 17=#f0c6c6
palette = 18=#1e2030
palette = 19=#363a4f
palette = 20=#5b6078
palette = 21=#f4dbd6

# Foreground & background colors
background = #24273a
foreground = #cad3f5
cursor-color = #cad3f5
selection-background = #cad3f5
selection-foreground = #363a4f
search-background = #eed49f
search-foreground = #1e2030
search-selected-background = #f5a97f
search-selected-foreground = #1e2030

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #b7bdf8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7dc4e4
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
