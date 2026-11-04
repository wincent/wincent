-- vim: ft=lua
-- Rosé Pine Dawn theme for Rex
-- Scheme Author: Emilia Dunfelt &lt;edun@dunfelt.se&gt;
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

local name = "base16-rose-pine-dawn"
local variant = "light"

-- This must match themes/ghostty/base16-rose-pine-dawn exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Rosé Pine Dawn theme for Ghostty
# Scheme Author: Emilia Dunfelt &lt;edun@dunfelt.se&gt;
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#faf4ed
palette = 1=#b4637a
palette = 2=#286983
palette = 3=#d7827e
palette = 4=#907aa9
palette = 5=#ea9d34
palette = 6=#56949f
palette = 7=#575279
palette = 8=#9893a5
palette = 9=#b4637a
palette = 10=#286983
palette = 11=#d7827e
palette = 12=#907aa9
palette = 13=#ea9d34
palette = 14=#56949f
palette = 15=#cecacd
palette = 16=#ea9d34
palette = 17=#cecacd
palette = 18=#fffaf3
palette = 19=#f2e9de
palette = 20=#797593
palette = 21=#575279

# Foreground & background colors
background = #faf4ed
foreground = #575279
cursor-color = #575279
selection-background = #575279
selection-foreground = #f2e9de
search-background = #d7827e
search-foreground = #cecacd
search-selected-background = #ea9d34
search-selected-foreground = #cecacd

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #cecacd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #907aa9
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
