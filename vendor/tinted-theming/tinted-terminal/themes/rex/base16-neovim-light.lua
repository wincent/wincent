-- vim: ft=lua
-- Neovim Light theme for Rex
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

local name = "base16-neovim-light"
local variant = "light"

-- This must match themes/ghostty/base16-neovim-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Neovim Light theme for Ghostty
# Scheme Author: https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#e0e2ea
palette = 1=#590008
palette = 2=#005523
palette = 3=#6b5300
palette = 4=#004c73
palette = 5=#470045
palette = 6=#007373
palette = 7=#14161b
palette = 8=#4f5258
palette = 9=#590008
palette = 10=#005523
palette = 11=#6b5300
palette = 12=#004c73
palette = 13=#470045
palette = 14=#007373
palette = 15=#07080d
palette = 16=#8b4513
palette = 17=#a52a2a
palette = 18=#eef1f8
palette = 19=#9b9ea4
palette = 20=#2c2e33
palette = 21=#07080d

# Foreground & background colors
background = #e0e2ea
foreground = #14161b
cursor-color = #14161b
selection-background = #14161b
selection-foreground = #9b9ea4
search-background = #6b5300
search-foreground = #07080d
search-selected-background = #8b4513
search-selected-foreground = #07080d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #07080d
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #004c73
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
