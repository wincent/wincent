-- vim: ft=lua
-- Catppuccin Latte theme for Rex
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

local name = "base24-catppuccin-latte"
local variant = "light"

-- This must match themes/ghostty/base24-catppuccin-latte exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Catppuccin Latte theme for Ghostty
# Scheme Author: https://github.com/catppuccin/catppuccin
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#eff1f5
palette = 1=#d20f39
palette = 2=#40a02b
palette = 3=#df8e1d
palette = 4=#1e66f5
palette = 5=#8839ef
palette = 6=#179299
palette = 7=#4c4f69
palette = 8=#bcc0cc
palette = 9=#e64553
palette = 10=#40a02b
palette = 11=#dc8a78
palette = 12=#209fb5
palette = 13=#ea76cb
palette = 14=#04a5e5
palette = 15=#7287fd
palette = 16=#fe640b
palette = 17=#dd7878
palette = 18=#e6e9ef
palette = 19=#ccd0da
palette = 20=#acb0be
palette = 21=#dc8a78

# Foreground & background colors
background = #eff1f5
foreground = #4c4f69
cursor-color = #4c4f69
selection-background = #4c4f69
selection-foreground = #ccd0da
search-background = #df8e1d
search-foreground = #e6e9ef
search-selected-background = #fe640b
search-selected-foreground = #e6e9ef

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #7287fd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #209fb5
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
