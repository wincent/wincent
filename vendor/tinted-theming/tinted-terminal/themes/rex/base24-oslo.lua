-- vim: ft=lua
-- Oslo theme for Rex
-- Scheme Author: xscriptor (https://github.com/xscriptor)
-- Scheme System: base24
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

local name = "base24-oslo"
local variant = "dark"

-- This must match themes/ghostty/base24-oslo exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Oslo theme for Ghostty
# Scheme Author: xscriptor (https://github.com/xscriptor)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#3f4451
palette = 1=#e05561
palette = 2=#8cc265
palette = 3=#d18f52
palette = 4=#4aa5f0
palette = 5=#c162de
palette = 6=#42b3c2
palette = 7=#abb2bf
palette = 8=#6c727f
palette = 9=#ff616e
palette = 10=#a5e075
palette = 11=#f0a45d
palette = 12=#4dc4ff
palette = 13=#de73ff
palette = 14=#4cd1e0
palette = 15=#ffffff
palette = 16=#d8725a
palette = 17=#a26257
palette = 18=#474c59
palette = 19=#4c515e
palette = 20=#7a808e
palette = 21=#bcc1cc

# Foreground & background colors
background = #3f4451
foreground = #abb2bf
cursor-color = #abb2bf
selection-background = #abb2bf
selection-foreground = #4c515e
search-background = #d18f52
search-foreground = #474c59
search-selected-background = #d8725a
search-selected-foreground = #474c59

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4dc4ff
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
