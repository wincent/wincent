-- vim: ft=lua
-- Gotham theme for Rex
-- Scheme Author: Andrea Leopardi (arranged by Brett Jones)
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

local name = "base16-gotham"
local variant = "dark"

-- This must match themes/ghostty/base16-gotham exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Gotham theme for Ghostty
# Scheme Author: Andrea Leopardi (arranged by Brett Jones)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0c1014
palette = 1=#c23127
palette = 2=#33859e
palette = 3=#edb443
palette = 4=#195466
palette = 5=#888ca6
palette = 6=#2aa889
palette = 7=#599cab
palette = 8=#0a3749
palette = 9=#c23127
palette = 10=#33859e
palette = 11=#edb443
palette = 12=#195466
palette = 13=#888ca6
palette = 14=#2aa889
palette = 15=#d3ebe9
palette = 16=#d26937
palette = 17=#4e5166
palette = 18=#11151c
palette = 19=#091f2e
palette = 20=#245361
palette = 21=#99d1ce

# Foreground & background colors
background = #0c1014
foreground = #599cab
cursor-color = #599cab
selection-background = #599cab
selection-foreground = #091f2e
search-background = #edb443
search-foreground = #11151c
search-selected-background = #d26937
search-selected-foreground = #11151c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d3ebe9
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #195466
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
