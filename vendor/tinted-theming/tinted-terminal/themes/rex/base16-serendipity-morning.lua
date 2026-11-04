-- vim: ft=lua
-- Serendipity Morning theme for Rex
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

local name = "base16-serendipity-morning"
local variant = "light"

-- This must match themes/ghostty/base16-serendipity-morning exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Serendipity Morning theme for Ghostty
# Scheme Author: Micheal Andreuzza (https://michaelandreuzza.com/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f6f7fb
palette = 1=#c25a4d
palette = 2=#2f7aab
palette = 3=#785fd0
palette = 4=#6288d8
palette = 5=#785fd0
palette = 6=#e58678
palette = 7=#3f4363
palette = 8=#6d7296
palette = 9=#c25a4d
palette = 10=#2f7aab
palette = 11=#785fd0
palette = 12=#6288d8
palette = 13=#785fd0
palette = 14=#e58678
palette = 15=#f6f7fb
palette = 16=#c25a4d
palette = 17=#2f7aab
palette = 18=#eaebee
palette = 19=#eaebee
palette = 20=#505575
palette = 21=#3f4363

# Foreground & background colors
background = #f6f7fb
foreground = #3f4363
cursor-color = #3f4363
selection-background = #3f4363
selection-foreground = #eaebee
search-background = #785fd0
search-foreground = #f6f7fb
search-selected-background = #c25a4d
search-selected-foreground = #f6f7fb

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f6f7fb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6288d8
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
