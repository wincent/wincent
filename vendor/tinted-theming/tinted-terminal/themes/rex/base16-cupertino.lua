-- vim: ft=lua
-- Cupertino theme for Rex
-- Scheme Author: Defman21
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

local name = "base16-cupertino"
local variant = "light"

-- This must match themes/ghostty/base16-cupertino exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Cupertino theme for Ghostty
# Scheme Author: Defman21
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#c41a15
palette = 2=#007400
palette = 3=#826b28
palette = 4=#0000ff
palette = 5=#a90d91
palette = 6=#318495
palette = 7=#404040
palette = 8=#808080
palette = 9=#c41a15
palette = 10=#007400
palette = 11=#826b28
palette = 12=#0000ff
palette = 13=#a90d91
palette = 14=#318495
palette = 15=#5e5e5e
palette = 16=#eb8500
palette = 17=#826b28
palette = 18=#c0c0c0
palette = 19=#c0c0c0
palette = 20=#808080
palette = 21=#404040

# Foreground & background colors
background = #ffffff
foreground = #404040
cursor-color = #404040
selection-background = #404040
selection-foreground = #c0c0c0
search-background = #826b28
search-foreground = #5e5e5e
search-selected-background = #eb8500
search-selected-foreground = #5e5e5e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #5e5e5e
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0000ff
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
