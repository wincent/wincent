-- vim: ft=lua
-- Penumbra Dark Contrast Plus theme for Rex
-- Scheme Author: Zachary Weiss (https://github.com/zacharyweiss)
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

local name = "base16-penumbra-dark-contrast-plus"
local variant = "dark"

-- This must match themes/ghostty/base16-penumbra-dark-contrast-plus exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Penumbra Dark Contrast Plus theme for Ghostty
# Scheme Author: Zachary Weiss (https://github.com/zacharyweiss)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#181b1f
palette = 1=#df7f78
palette = 2=#50b584
palette = 3=#9ca748
palette = 4=#61a3e6
palette = 5=#a48fe1
palette = 6=#00b3c2
palette = 7=#cecece
palette = 8=#636363
palette = 9=#df7f78
palette = 10=#50b584
palette = 11=#9ca748
palette = 12=#61a3e6
palette = 13=#a48fe1
palette = 14=#00b3c2
palette = 15=#fffdfb
palette = 16=#ce9042
palette = 17=#d080b6
palette = 18=#24272b
palette = 19=#3e4044
palette = 20=#9e9e9e
palette = 21=#fff7ed

# Foreground & background colors
background = #181b1f
foreground = #cecece
cursor-color = #cecece
selection-background = #cecece
selection-foreground = #3e4044
search-background = #9ca748
search-foreground = #24272b
search-selected-background = #ce9042
search-selected-foreground = #24272b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fffdfb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #61a3e6
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
