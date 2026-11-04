-- vim: ft=lua
-- One Half Light theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-one-half-light"
local variant = "dark"

-- This must match themes/ghostty/base24-one-half-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# One Half Light theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2a2b32
palette = 1=#e45649
palette = 2=#4fa14f
palette = 3=#c0aa00
palette = 4=#0084bc
palette = 5=#a625a4
palette = 6=#0996b3
palette = 7=#cfd0d2
palette = 8=#797c84
palette = 9=#df6c75
palette = 10=#98c379
palette = 11=#e4c07a
palette = 12=#61afef
palette = 13=#c577dd
palette = 14=#56b5c1
palette = 15=#ffffff
palette = 16=#c08400
palette = 17=#722b24
palette = 18=#373942
palette = 19=#4f525d
palette = 20=#a4a6ab
palette = 21=#fafafa

# Foreground & background colors
background = #2a2b32
foreground = #cfd0d2
cursor-color = #cfd0d2
selection-background = #cfd0d2
selection-foreground = #4f525d
search-background = #c0aa00
search-foreground = #373942
search-selected-background = #c08400
search-selected-foreground = #373942

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #61afef
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
