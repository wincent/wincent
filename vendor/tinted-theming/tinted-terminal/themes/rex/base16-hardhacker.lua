-- vim: ft=lua
-- Hardhacker theme for Rex
-- Scheme Author: fe2-Nyxar, based on the https://github.com/hardhackerlabs
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

local name = "base16-hardhacker"
local variant = "dark"

-- This must match themes/ghostty/base16-hardhacker exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Hardhacker theme for Ghostty
# Scheme Author: fe2-Nyxar, based on the https://github.com/hardhackerlabs
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#211e2a
palette = 1=#e965a5
palette = 2=#b1f2a7
palette = 3=#ebde76
palette = 4=#95a6f4
palette = 5=#ff79c6
palette = 6=#b3f4f3
palette = 7=#e4dee9
palette = 8=#6e6780
palette = 9=#e965a5
palette = 10=#b1f2a7
palette = 11=#ebde76
palette = 12=#95a6f4
palette = 13=#ff79c6
palette = 14=#b3f4f3
palette = 15=#ffffff
palette = 16=#f4b870
palette = 17=#bd93f9
palette = 18=#2c2737
palette = 19=#3f3951
palette = 20=#8a829e
palette = 21=#f2e8f0

# Foreground & background colors
background = #211e2a
foreground = #e4dee9
cursor-color = #e4dee9
selection-background = #e4dee9
selection-foreground = #3f3951
search-background = #ebde76
search-foreground = #2c2737
search-selected-background = #f4b870
search-selected-foreground = #2c2737

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #95a6f4
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
