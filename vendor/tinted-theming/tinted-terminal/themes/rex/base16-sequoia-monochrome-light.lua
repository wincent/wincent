-- vim: ft=lua
-- Sequoia Monochrome Light theme for Rex
-- Scheme Author: Micheal Andreuzza (https://michaelandreuzza.com/)
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

local name = "base16-sequoia-monochrome-light"
local variant = "light"

-- This must match themes/ghostty/base16-sequoia-monochrome-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Sequoia Monochrome Light theme for Ghostty
# Scheme Author: Micheal Andreuzza (https://michaelandreuzza.com/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#edeef2
palette = 1=#525666
palette = 2=#2e3038
palette = 3=#50535e
palette = 4=#5f6370
palette = 5=#50535e
palette = 6=#454752
palette = 7=#282930
palette = 8=#9da2ad
palette = 9=#525666
palette = 10=#2e3038
palette = 11=#50535e
palette = 12=#5f6370
palette = 13=#50535e
palette = 14=#454752
palette = 15=#0f1014
palette = 16=#525666
palette = 17=#2e3038
palette = 18=#e2e3e8
palette = 19=#e2e3e8
palette = 20=#42434e
palette = 21=#282930

# Foreground & background colors
background = #edeef2
foreground = #282930
cursor-color = #282930
selection-background = #282930
selection-foreground = #e2e3e8
search-background = #50535e
search-foreground = #0f1014
search-selected-background = #525666
search-selected-foreground = #0f1014

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #0f1014
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5f6370
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
