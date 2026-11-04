-- vim: ft=lua
-- Snazzy theme for Rex
-- Scheme Author: Chawye Hsu (https://github.com/chawyehsu), based on Hyper Snazzy Theme (https://github.com/sindresorhus/hyper-snazzy)
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

local name = "base16-snazzy"
local variant = "dark"

-- This must match themes/ghostty/base16-snazzy exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Snazzy theme for Ghostty
# Scheme Author: Chawye Hsu (https://github.com/chawyehsu), based on Hyper Snazzy Theme (https://github.com/sindresorhus/hyper-snazzy)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#282a36
palette = 1=#ff5c57
palette = 2=#5af78e
palette = 3=#f3f99d
palette = 4=#57c7ff
palette = 5=#ff6ac1
palette = 6=#9aedfe
palette = 7=#e2e4e5
palette = 8=#78787e
palette = 9=#ff5c57
palette = 10=#5af78e
palette = 11=#f3f99d
palette = 12=#57c7ff
palette = 13=#ff6ac1
palette = 14=#9aedfe
palette = 15=#f1f1f0
palette = 16=#ff9f43
palette = 17=#b2643c
palette = 18=#34353e
palette = 19=#43454f
palette = 20=#a5a5a9
palette = 21=#eff0eb

# Foreground & background colors
background = #282a36
foreground = #e2e4e5
cursor-color = #e2e4e5
selection-background = #e2e4e5
selection-foreground = #43454f
search-background = #f3f99d
search-foreground = #34353e
search-selected-background = #ff9f43
search-selected-foreground = #34353e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f1f1f0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #57c7ff
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
