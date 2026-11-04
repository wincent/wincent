-- vim: ft=lua
-- Rebecca theme for Rex
-- Scheme Author: Victor Borja (http://github.com/vic) based on Rebecca Theme (http://github.com/vic/rebecca-theme)
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

local name = "base16-rebecca"
local variant = "dark"

-- This must match themes/ghostty/base16-rebecca exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Rebecca theme for Ghostty
# Scheme Author: Victor Borja (http://github.com/vic) based on Rebecca Theme (http://github.com/vic/rebecca-theme)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#292a44
palette = 1=#a0a0c5
palette = 2=#6dfedf
palette = 3=#ae81ff
palette = 4=#2de0a7
palette = 5=#7aa5ff
palette = 6=#8eaee0
palette = 7=#f1eff8
palette = 8=#666699
palette = 9=#a0a0c5
palette = 10=#6dfedf
palette = 11=#ae81ff
palette = 12=#2de0a7
palette = 13=#7aa5ff
palette = 14=#8eaee0
palette = 15=#53495d
palette = 16=#efe4a1
palette = 17=#ff79c6
palette = 18=#663399
palette = 19=#383a62
palette = 20=#a0a0c5
palette = 21=#ccccff

# Foreground & background colors
background = #292a44
foreground = #f1eff8
cursor-color = #f1eff8
selection-background = #f1eff8
selection-foreground = #383a62
search-background = #ae81ff
search-foreground = #663399
search-selected-background = #efe4a1
search-selected-foreground = #663399

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #53495d
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #2de0a7
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
