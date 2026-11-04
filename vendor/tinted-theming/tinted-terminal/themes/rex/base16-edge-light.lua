-- vim: ft=lua
-- Edge Light theme for Rex
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

local name = "base16-edge-light"
local variant = "light"

-- This must match themes/ghostty/base16-edge-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Edge Light theme for Ghostty
# Scheme Author: cjayross (https://github.com/cjayross), Tinted Theming (https://github.com/tinted-theming)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fafafa
palette = 1=#db7070
palette = 2=#7c9f4b
palette = 3=#ebcc1a
palette = 4=#6587bf
palette = 5=#b870ce
palette = 6=#509c93
palette = 7=#474752
palette = 8=#9197a1
palette = 9=#db7070
palette = 10=#7c9f4b
palette = 11=#ebcc1a
palette = 12=#6587bf
palette = 13=#b870ce
palette = 14=#509c93
palette = 15=#2e2e38
palette = 16=#eba31a
palette = 17=#509c93
palette = 18=#e3e5e8
palette = 19=#acb1b9
palette = 20=#5e646f
palette = 21=#3a3a46

# Foreground & background colors
background = #fafafa
foreground = #474752
cursor-color = #474752
selection-background = #474752
selection-foreground = #acb1b9
search-background = #ebcc1a
search-foreground = #2e2e38
search-selected-background = #eba31a
search-selected-foreground = #2e2e38

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #2e2e38
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6587bf
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
