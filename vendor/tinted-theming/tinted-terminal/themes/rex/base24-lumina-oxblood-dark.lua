-- vim: ft=lua
-- Lumina Oxblood Dark theme for Rex
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

local name = "base24-lumina-oxblood-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-oxblood-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Oxblood Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#200f16
palette = 1=#db6c63
palette = 2=#7dc797
palette = 3=#f9c875
palette = 4=#9ac3f8
palette = 5=#bfb6f9
palette = 6=#6fcad4
palette = 7=#e8d6dc
palette = 8=#3b262e
palette = 9=#e78f86
palette = 10=#9ce0b2
palette = 11=#ffe4b8
palette = 12=#c2dcff
palette = 13=#f2d5ff
palette = 14=#8de4ed
palette = 15=#e8d6dc
palette = 16=#fbac74
palette = 17=#ddb7ed
palette = 18=#26131b
palette = 19=#301c24
palette = 20=#79616a
palette = 21=#bdacb2

# Foreground & background colors
background = #200f16
foreground = #e8d6dc
cursor-color = #e8d6dc
selection-background = #e8d6dc
selection-foreground = #301c24
search-background = #f9c875
search-foreground = #26131b
search-selected-background = #fbac74
search-selected-foreground = #26131b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e8d6dc
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #c2dcff
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
