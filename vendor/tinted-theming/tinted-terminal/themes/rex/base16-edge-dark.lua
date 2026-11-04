-- vim: ft=lua
-- Edge Dark theme for Rex
-- Scheme Author: cjayross (https://github.com/cjayross), Tinted Theming (https://github.com/tinted-theming)
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

local name = "base16-edge-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-edge-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Edge Dark theme for Ghostty
# Scheme Author: cjayross (https://github.com/cjayross), Tinted Theming (https://github.com/tinted-theming)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#262729
palette = 1=#e77171
palette = 2=#a1bf78
palette = 3=#dbb774
palette = 4=#73b3e7
palette = 5=#d390e7
palette = 6=#5ebaa5
palette = 7=#afb2b5
palette = 8=#4a4c4f
palette = 9=#e77171
palette = 10=#a1bf78
palette = 11=#dbb774
palette = 12=#73b3e7
palette = 13=#d390e7
palette = 14=#5ebaa5
palette = 15=#e4e5e6
palette = 16=#eba31a
palette = 17=#5ebaa5
palette = 18=#313235
palette = 19=#3d3f42
palette = 20=#95989d
palette = 21=#caccce

# Foreground & background colors
background = #262729
foreground = #afb2b5
cursor-color = #afb2b5
selection-background = #afb2b5
selection-foreground = #3d3f42
search-background = #dbb774
search-foreground = #313235
search-selected-background = #eba31a
search-selected-foreground = #313235

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e4e5e6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #73b3e7
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
