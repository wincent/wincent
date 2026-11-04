-- vim: ft=lua
-- Primer Dark theme for Rex
-- Scheme Author: Jimmy Lin
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

local name = "base16-primer-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-primer-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Primer Dark theme for Ghostty
# Scheme Author: Jimmy Lin
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#010409
palette = 1=#ff7b72
palette = 2=#3fb950
palette = 3=#d29922
palette = 4=#58a6ff
palette = 5=#f778ba
palette = 6=#a5d6ff
palette = 7=#b1bac4
palette = 8=#484f58
palette = 9=#ff7b72
palette = 10=#3fb950
palette = 11=#d29922
palette = 12=#58a6ff
palette = 13=#f778ba
palette = 14=#a5d6ff
palette = 15=#f0f6fc
palette = 16=#f0883e
palette = 17=#bd561d
palette = 18=#21262d
palette = 19=#30363d
palette = 20=#8b949e
palette = 21=#c9d1d9

# Foreground & background colors
background = #010409
foreground = #b1bac4
cursor-color = #b1bac4
selection-background = #b1bac4
selection-foreground = #30363d
search-background = #d29922
search-foreground = #21262d
search-selected-background = #f0883e
search-selected-foreground = #21262d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f0f6fc
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #58a6ff
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
