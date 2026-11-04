-- vim: ft=lua
-- Chinoiserie theme for Rex
-- Scheme Author: Di Wang (https://cs.cmu.edu/~diw3)
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

local name = "base16-chinoiserie"
local variant = "light"

-- This must match themes/ghostty/base16-chinoiserie exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Chinoiserie theme for Ghostty
# Scheme Author: Di Wang (https://cs.cmu.edu/~diw3)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#c04851
palette = 2=#428675
palette = 3=#d6a01d
palette = 4=#815c94
palette = 5=#c08eaf
palette = 6=#2b73af
palette = 7=#4a4035
palette = 8=#80766e
palette = 9=#c04851
palette = 10=#428675
palette = 11=#d6a01d
palette = 12=#815c94
palette = 13=#c08eaf
palette = 14=#2b73af
palette = 15=#131124
palette = 16=#fb8b05
palette = 17=#945833
palette = 18=#e0e0e0
palette = 19=#d6d6d6
palette = 20=#918072
palette = 21=#2f2f35

# Foreground & background colors
background = #ffffff
foreground = #4a4035
cursor-color = #4a4035
selection-background = #4a4035
selection-foreground = #d6d6d6
search-background = #d6a01d
search-foreground = #131124
search-selected-background = #fb8b05
search-selected-foreground = #131124

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #131124
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #815c94
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
