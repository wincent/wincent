-- vim: ft=lua
-- Dimmed Monokai theme for Rex
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

local name = "base24-dimmed-monokai"
local variant = "dark"

-- This must match themes/ghostty/base24-dimmed-monokai exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Dimmed Monokai theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e1e1e
palette = 1=#be3e48
palette = 2=#869a3a
palette = 3=#176ce3
palette = 4=#4e76a1
palette = 5=#855b8d
palette = 6=#568ea3
palette = 7=#acafac
palette = 8=#949593
palette = 9=#fb001e
palette = 10=#0e712e
palette = 11=#c37033
palette = 12=#176ce3
palette = 13=#fb0067
palette = 14=#2d6f6c
palette = 15=#fcffb8
palette = 16=#c4a535
palette = 17=#5f1f24
palette = 18=#3a3c43
palette = 19=#888987
palette = 20=#a0a2a0
palette = 21=#b8bcb9

# Foreground & background colors
background = #1e1e1e
foreground = #acafac
cursor-color = #acafac
selection-background = #acafac
selection-foreground = #888987
search-background = #176ce3
search-foreground = #3a3c43
search-selected-background = #c4a535
search-selected-foreground = #3a3c43

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fcffb8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #176ce3
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
