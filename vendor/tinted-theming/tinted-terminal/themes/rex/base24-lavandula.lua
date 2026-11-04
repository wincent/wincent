-- vim: ft=lua
-- Lavandula theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-lavandula"
local variant = "dark"

-- This must match themes/ghostty/base24-lavandula exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lavandula theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#050014
palette = 1=#7c1525
palette = 2=#337e6f
palette = 3=#8e86df
palette = 4=#4f4a7f
palette = 5=#593f7e
palette = 6=#57767f
palette = 7=#645d6f
palette = 8=#463c53
palette = 9=#df5066
palette = 10=#52e0c4
palette = 11=#e0c286
palette = 12=#8e86df
palette = 13=#a675df
palette = 14=#9ad3df
palette = 15=#8c91fa
palette = 16=#7f6f49
palette = 17=#3e0a12
palette = 18=#230045
palette = 19=#372c46
palette = 20=#554d61
palette = 21=#736e7d

# Foreground & background colors
background = #050014
foreground = #645d6f
cursor-color = #645d6f
selection-background = #645d6f
selection-foreground = #372c46
search-background = #8e86df
search-foreground = #230045
search-selected-background = #7f6f49
search-selected-foreground = #230045

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #8c91fa
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8e86df
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
