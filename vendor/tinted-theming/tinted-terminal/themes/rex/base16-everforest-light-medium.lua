-- vim: ft=lua
-- Everforest Light (Medium) theme for Rex
-- Scheme Author: Márcio Sobel (https://github.com/marciosobel)
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

local name = "base16-everforest-light-medium"
local variant = "light"

-- This must match themes/ghostty/base16-everforest-light-medium exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Everforest Light (Medium) theme for Ghostty
# Scheme Author: Márcio Sobel (https://github.com/marciosobel)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fdf6e3
palette = 1=#f85552
palette = 2=#8da101
palette = 3=#dfa000
palette = 4=#3a94c5
palette = 5=#df69ba
palette = 6=#35a77c
palette = 7=#5c6a72
palette = 8=#939f91
palette = 9=#f85552
palette = 10=#8da101
palette = 11=#dfa000
palette = 12=#3a94c5
palette = 13=#df69ba
palette = 14=#35a77c
palette = 15=#2d353b
palette = 16=#f57d26
palette = 17=#829181
palette = 18=#f4f0d9
palette = 19=#e6e2cc
palette = 20=#829181
palette = 21=#475258

# Foreground & background colors
background = #fdf6e3
foreground = #5c6a72
cursor-color = #5c6a72
selection-background = #5c6a72
selection-foreground = #e6e2cc
search-background = #dfa000
search-foreground = #2d353b
search-selected-background = #f57d26
search-selected-foreground = #2d353b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #2d353b
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3a94c5
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
