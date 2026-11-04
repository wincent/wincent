-- vim: ft=lua
-- Shapeshifter theme for Rex
-- Scheme Author: Tyler Benziger (http://tybenz.com)
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

local name = "base16-shapeshifter"
local variant = "light"

-- This must match themes/ghostty/base16-shapeshifter exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Shapeshifter theme for Ghostty
# Scheme Author: Tyler Benziger (http://tybenz.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f9f9f9
palette = 1=#e92f2f
palette = 2=#0ed839
palette = 3=#dddd13
palette = 4=#3b48e3
palette = 5=#f996e2
palette = 6=#23edda
palette = 7=#102015
palette = 8=#555555
palette = 9=#e92f2f
palette = 10=#0ed839
palette = 11=#dddd13
palette = 12=#3b48e3
palette = 13=#f996e2
palette = 14=#23edda
palette = 15=#000000
palette = 16=#e09448
palette = 17=#69542d
palette = 18=#e0e0e0
palette = 19=#ababab
palette = 20=#343434
palette = 21=#040404

# Foreground & background colors
background = #f9f9f9
foreground = #102015
cursor-color = #102015
selection-background = #102015
selection-foreground = #ababab
search-background = #dddd13
search-foreground = #000000
search-selected-background = #e09448
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #000000
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3b48e3
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
