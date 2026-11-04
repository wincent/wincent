-- vim: ft=lua
-- Equilibrium Dark theme for Rex
-- Scheme Author: Carlo Abelli
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

local name = "base16-equilibrium-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-equilibrium-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Equilibrium Dark theme for Ghostty
# Scheme Author: Carlo Abelli
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0c1118
palette = 1=#f04339
palette = 2=#7f8b00
palette = 3=#bb8801
palette = 4=#008dd1
palette = 5=#6a7fd2
palette = 6=#00948b
palette = 7=#afaba2
palette = 8=#7b776e
palette = 9=#f04339
palette = 10=#7f8b00
palette = 11=#bb8801
palette = 12=#008dd1
palette = 13=#6a7fd2
palette = 14=#00948b
palette = 15=#e7e2d9
palette = 16=#df5923
palette = 17=#e3488e
palette = 18=#181c22
palette = 19=#22262d
palette = 20=#949088
palette = 21=#cac6bd

# Foreground & background colors
background = #0c1118
foreground = #afaba2
cursor-color = #afaba2
selection-background = #afaba2
selection-foreground = #22262d
search-background = #bb8801
search-foreground = #181c22
search-selected-background = #df5923
search-selected-foreground = #181c22

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e7e2d9
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #008dd1
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
