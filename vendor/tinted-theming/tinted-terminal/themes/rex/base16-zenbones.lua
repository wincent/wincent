-- vim: ft=lua
-- Zenbones theme for Rex
-- Scheme Author: mcchrish
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

local name = "base16-zenbones"
local variant = "dark"

-- This must match themes/ghostty/base16-zenbones exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Zenbones theme for Ghostty
# Scheme Author: mcchrish
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#191919
palette = 1=#3d3839
palette = 2=#d68c67
palette = 3=#8bae68
palette = 4=#cf86c1
palette = 5=#65b8c1
palette = 6=#61abda
palette = 7=#b279a7
palette = 8=#b77e64
palette = 9=#3d3839
palette = 10=#d68c67
palette = 11=#8bae68
palette = 12=#cf86c1
palette = 13=#65b8c1
palette = 14=#61abda
palette = 15=#bbbbbb
palette = 16=#e8838f
palette = 17=#8e8e8e
palette = 18=#de6e7c
palette = 19=#819b69
palette = 20=#6099c0
palette = 21=#66a5ad

# Foreground & background colors
background = #191919
foreground = #b279a7
cursor-color = #b279a7
selection-background = #b279a7
selection-foreground = #819b69
search-background = #8bae68
search-foreground = #de6e7c
search-selected-background = #e8838f
search-selected-foreground = #de6e7c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #bbbbbb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #cf86c1
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
