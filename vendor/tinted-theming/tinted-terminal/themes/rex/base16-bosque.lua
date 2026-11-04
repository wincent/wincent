-- vim: ft=lua
-- Bosque theme for Rex
-- Scheme Author: Teshre
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

local name = "base16-bosque"
local variant = "dark"

-- This must match themes/ghostty/base16-bosque exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Bosque theme for Ghostty
# Scheme Author: Teshre
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0e1410
palette = 1=#e2706a
palette = 2=#6fc56e
palette = 3=#c8b84a
palette = 4=#6dae9e
palette = 5=#b894d0
palette = 6=#5fd0b8
palette = 7=#cfe5d2
palette = 8=#5c6e5e
palette = 9=#e2706a
palette = 10=#6fc56e
palette = 11=#c8b84a
palette = 12=#6dae9e
palette = 13=#b894d0
palette = 14=#5fd0b8
palette = 15=#e4f0e2
palette = 16=#7dc97a
palette = 17=#35503e
palette = 18=#16211a
palette = 19=#1e3023
palette = 20=#96aa98
palette = 21=#daebda

# Foreground & background colors
background = #0e1410
foreground = #cfe5d2
cursor-color = #cfe5d2
selection-background = #cfe5d2
selection-foreground = #1e3023
search-background = #c8b84a
search-foreground = #16211a
search-selected-background = #7dc97a
search-selected-foreground = #16211a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e4f0e2
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6dae9e
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
