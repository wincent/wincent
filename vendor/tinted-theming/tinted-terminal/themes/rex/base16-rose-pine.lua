-- vim: ft=lua
-- Rosé Pine theme for Rex
-- Scheme Author: Emilia Dunfelt &lt;edun@dunfelt.se&gt;
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

local name = "base16-rose-pine"
local variant = "dark"

-- This must match themes/ghostty/base16-rose-pine exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Rosé Pine theme for Ghostty
# Scheme Author: Emilia Dunfelt &lt;edun@dunfelt.se&gt;
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#191724
palette = 1=#eb6f92
palette = 2=#31748f
palette = 3=#ebbcba
palette = 4=#c4a7e7
palette = 5=#f6c177
palette = 6=#9ccfd8
palette = 7=#e0def4
palette = 8=#6e6a86
palette = 9=#eb6f92
palette = 10=#31748f
palette = 11=#ebbcba
palette = 12=#c4a7e7
palette = 13=#f6c177
palette = 14=#9ccfd8
palette = 15=#524f67
palette = 16=#f6c177
palette = 17=#524f67
palette = 18=#1f1d2e
palette = 19=#26233a
palette = 20=#908caa
palette = 21=#e0def4

# Foreground & background colors
background = #191724
foreground = #e0def4
cursor-color = #e0def4
selection-background = #e0def4
selection-foreground = #26233a
search-background = #ebbcba
search-foreground = #1f1d2e
search-selected-background = #f6c177
search-selected-foreground = #1f1d2e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #524f67
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #c4a7e7
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
