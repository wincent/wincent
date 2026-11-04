-- vim: ft=lua
-- Charcoal Light theme for Rex
-- Scheme Author: Mubin Muhammad (https://github.com/mubin6th)
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

local name = "base16-charcoal-light"
local variant = "light"

-- This must match themes/ghostty/base16-charcoal-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Charcoal Light theme for Ghostty
# Scheme Author: Mubin Muhammad (https://github.com/mubin6th)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#cabda0
palette = 1=#382e1b
palette = 2=#110e06
palette = 3=#110e06
palette = 4=#251e0f
palette = 5=#382e1b
palette = 6=#110e06
palette = 7=#382e1b
palette = 8=#645538
palette = 9=#382e1b
palette = 10=#110e06
palette = 11=#110e06
palette = 12=#251e0f
palette = 13=#382e1b
palette = 14=#110e06
palette = 15=#bcad8c
palette = 16=#110e06
palette = 17=#4b3e26
palette = 18=#bcad8c
palette = 19=#af9f7d
palette = 20=#110e06
palette = 21=#4b3e26

# Foreground & background colors
background = #cabda0
foreground = #382e1b
cursor-color = #382e1b
selection-background = #382e1b
selection-foreground = #af9f7d
search-background = #110e06
search-foreground = #bcad8c
search-selected-background = #110e06
search-selected-foreground = #bcad8c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #bcad8c
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #251e0f
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
