-- vim: ft=lua
-- Seti UI theme for Rex
-- Scheme Author: 
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

local name = "base16-seti"
local variant = "dark"

-- This must match themes/ghostty/base16-seti exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Seti UI theme for Ghostty
# Scheme Author: 
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#151718
palette = 1=#cd3f45
palette = 2=#9fca56
palette = 3=#e6cd69
palette = 4=#55b5db
palette = 5=#a074c4
palette = 6=#55dbbe
palette = 7=#d6d6d6
palette = 8=#41535b
palette = 9=#cd3f45
palette = 10=#9fca56
palette = 11=#e6cd69
palette = 12=#55b5db
palette = 13=#a074c4
palette = 14=#55dbbe
palette = 15=#ffffff
palette = 16=#db7b55
palette = 17=#8a553f
palette = 18=#282a2b
palette = 19=#3b758c
palette = 20=#43a5d5
palette = 21=#eeeeee

# Foreground & background colors
background = #151718
foreground = #d6d6d6
cursor-color = #d6d6d6
selection-background = #d6d6d6
selection-foreground = #3b758c
search-background = #e6cd69
search-foreground = #282a2b
search-selected-background = #db7b55
search-selected-foreground = #282a2b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #55b5db
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
