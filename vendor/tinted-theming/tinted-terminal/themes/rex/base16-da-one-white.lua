-- vim: ft=lua
-- Da One White theme for Rex
-- Scheme Author: NNB (https://github.com/NNBnh)
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

local name = "base16-da-one-white"
local variant = "light"

-- This must match themes/ghostty/base16-da-one-white exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Da One White theme for Ghostty
# Scheme Author: NNB (https://github.com/NNBnh)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#de5d6e
palette = 2=#76a85d
palette = 3=#b3684f
palette = 4=#5890f8
palette = 5=#c173d1
palette = 6=#64b5a7
palette = 7=#181818
palette = 8=#585858
palette = 9=#de5d6e
palette = 10=#76a85d
palette = 11=#b3684f
palette = 12=#5890f8
palette = 13=#c173d1
palette = 14=#64b5a7
palette = 15=#000000
palette = 16=#ff9470
palette = 17=#b3684f
palette = 18=#c8c8c8
palette = 19=#888888
palette = 20=#282828
palette = 21=#000000

# Foreground & background colors
background = #ffffff
foreground = #181818
cursor-color = #181818
selection-background = #181818
selection-foreground = #888888
search-background = #b3684f
search-foreground = #000000
search-selected-background = #ff9470
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #000000
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5890f8
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
