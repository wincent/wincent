-- vim: ft=lua
-- Aztec theme for Rex
-- Scheme Author: TheNeverMan (github.com/TheNeverMan)
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

local name = "base16-aztec"
local variant = "dark"

-- This must match themes/ghostty/base16-aztec exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Aztec theme for Ghostty
# Scheme Author: TheNeverMan (github.com/TheNeverMan)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#101600
palette = 1=#ee2e00
palette = 2=#63d932
palette = 3=#eebb00
palette = 4=#5b4a9f
palette = 5=#883e9f
palette = 6=#3d94a5
palette = 7=#ffda51
palette = 8=#2e2e05
palette = 9=#ee2e00
palette = 10=#63d932
palette = 11=#eebb00
palette = 12=#5b4a9f
palette = 13=#883e9f
palette = 14=#3d94a5
palette = 15=#ffeba0
palette = 16=#ee8800
palette = 17=#a928b9
palette = 18=#1a1e01
palette = 19=#242604
palette = 20=#ffd129
palette = 21=#ffe178

# Foreground & background colors
background = #101600
foreground = #ffda51
cursor-color = #ffda51
selection-background = #ffda51
selection-foreground = #242604
search-background = #eebb00
search-foreground = #1a1e01
search-selected-background = #ee8800
search-selected-foreground = #1a1e01

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffeba0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5b4a9f
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
