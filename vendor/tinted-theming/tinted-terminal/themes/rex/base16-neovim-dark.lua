-- vim: ft=lua
-- Neovim Dark theme for Rex
-- Scheme Author: https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c
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

local name = "base16-neovim-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-neovim-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Neovim Dark theme for Ghostty
# Scheme Author: https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#14161b
palette = 1=#ffc0b9
palette = 2=#b3f6c0
palette = 3=#fce094
palette = 4=#a6dbff
palette = 5=#ffcaff
palette = 6=#8cf8f7
palette = 7=#e0e2ea
palette = 8=#9b9ea4
palette = 9=#ffc0b9
palette = 10=#b3f6c0
palette = 11=#fce094
palette = 12=#a6dbff
palette = 13=#ffcaff
palette = 14=#8cf8f7
palette = 15=#eef1f8
palette = 16=#ffa500
palette = 17=#cd853f
palette = 18=#07080d
palette = 19=#4f5258
palette = 20=#c4c6cd
palette = 21=#eef1f8

# Foreground & background colors
background = #14161b
foreground = #e0e2ea
cursor-color = #e0e2ea
selection-background = #e0e2ea
selection-foreground = #4f5258
search-background = #fce094
search-foreground = #07080d
search-selected-background = #ffa500
search-selected-foreground = #07080d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #eef1f8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a6dbff
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
