-- vim: ft=lua
-- Lumina Oxblood Light theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
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

local name = "base24-lumina-oxblood-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-oxblood-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Oxblood Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fef2f4
palette = 1=#9b2827
palette = 2=#237742
palette = 3=#a1600a
palette = 4=#3166a6
palette = 5=#6556a3
palette = 6=#087380
palette = 7=#42222f
palette = 8=#deced1
palette = 9=#732926
palette = 10=#0f6131
palette = 11=#874e00
palette = 12=#1c5290
palette = 13=#683a7d
palette = 14=#005d68
palette = 15=#42222f
palette = 16=#9e511f
palette = 17=#82469d
palette = 18=#fbeaed
palette = 19=#efdee1
palette = 20=#918284
palette = 21=#514446

# Foreground & background colors
background = #fef2f4
foreground = #42222f
cursor-color = #42222f
selection-background = #42222f
selection-foreground = #efdee1
search-background = #a1600a
search-foreground = #fbeaed
search-selected-background = #9e511f
search-selected-foreground = #fbeaed

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #42222f
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1c5290
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
