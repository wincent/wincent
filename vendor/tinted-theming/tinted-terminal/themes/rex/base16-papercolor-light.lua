-- vim: ft=lua
-- PaperColor Light theme for Rex
-- Scheme Author: Jon Leopard (http://github.com/jonleopard), Tinted Theming (https://github.com/tinted-theming), based on PaperColor Theme (https://github.com/NLKNguyen/papercolor-theme)
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

local name = "base16-papercolor-light"
local variant = "light"

-- This must match themes/ghostty/base16-papercolor-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# PaperColor Light theme for Ghostty
# Scheme Author: Jon Leopard (http://github.com/jonleopard), Tinted Theming (https://github.com/tinted-theming), based on PaperColor Theme (https://github.com/NLKNguyen/papercolor-theme)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#eeeeee
palette = 1=#d70000
palette = 2=#008700
palette = 3=#d75f00
palette = 4=#005f87
palette = 5=#8700af
palette = 6=#0087af
palette = 7=#5e5e5e
palette = 8=#858585
palette = 9=#d70000
palette = 10=#008700
palette = 11=#d75f00
palette = 12=#005f87
palette = 13=#8700af
palette = 14=#0087af
palette = 15=#444444
palette = 16=#d75f00
palette = 17=#af0000
palette = 18=#c4c4c4
palette = 19=#9e9e9e
palette = 20=#6b6b6b
palette = 21=#525252

# Foreground & background colors
background = #eeeeee
foreground = #5e5e5e
cursor-color = #5e5e5e
selection-background = #5e5e5e
selection-foreground = #9e9e9e
search-background = #d75f00
search-foreground = #444444
search-selected-background = #d75f00
search-selected-foreground = #444444

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #444444
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #005f87
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
