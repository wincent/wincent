-- vim: ft=lua
-- Yesterday Night theme for Rex
-- Scheme Author: FroZnShiva (https://github.com/FroZnShiva)
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

local name = "base16-yesterday-night"
local variant = "dark"

-- This must match themes/ghostty/base16-yesterday-night exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Yesterday Night theme for Ghostty
# Scheme Author: FroZnShiva (https://github.com/FroZnShiva)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#343d46
palette = 1=#cc6666
palette = 2=#b5bd68
palette = 3=#f0c674
palette = 4=#81a2be
palette = 5=#b294bb
palette = 6=#8abeb7
palette = 7=#dfe1e8
palette = 8=#a7adba
palette = 9=#cc6666
palette = 10=#b5bd68
palette = 11=#f0c674
palette = 12=#81a2be
palette = 13=#b294bb
palette = 14=#8abeb7
palette = 15=#ffffff
palette = 16=#de935f
palette = 17=#a3685a
palette = 18=#4f5b66
palette = 19=#65737e
palette = 20=#c0c5ce
palette = 21=#eff1f5

# Foreground & background colors
background = #343d46
foreground = #dfe1e8
cursor-color = #dfe1e8
selection-background = #dfe1e8
selection-foreground = #65737e
search-background = #f0c674
search-foreground = #4f5b66
search-selected-background = #de935f
search-selected-foreground = #4f5b66

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #81a2be
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
