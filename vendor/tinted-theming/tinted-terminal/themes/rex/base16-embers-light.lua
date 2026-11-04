-- vim: ft=lua
-- Embers Light theme for Rex
-- Scheme Author: Jannik Siebert (https://github.com/janniks)
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

local name = "base16-embers-light"
local variant = "light"

-- This must match themes/ghostty/base16-embers-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Embers Light theme for Ghostty
# Scheme Author: Jannik Siebert (https://github.com/janniks)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#dbd6d1
palette = 1=#826d57
palette = 2=#57826d
palette = 3=#6d8257
palette = 4=#6d5782
palette = 5=#82576d
palette = 6=#576d82
palette = 7=#433b32
palette = 8=#8a8075
palette = 9=#826d57
palette = 10=#57826d
palette = 11=#6d8257
palette = 12=#6d5782
palette = 13=#82576d
palette = 14=#576d82
palette = 15=#16130f
palette = 16=#828257
palette = 17=#825757
palette = 18=#beb6ae
palette = 19=#a39a90
palette = 20=#5a5047
palette = 21=#2c2620

# Foreground & background colors
background = #dbd6d1
foreground = #433b32
cursor-color = #433b32
selection-background = #433b32
selection-foreground = #a39a90
search-background = #6d8257
search-foreground = #16130f
search-selected-background = #828257
search-selected-foreground = #16130f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #16130f
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6d5782
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
