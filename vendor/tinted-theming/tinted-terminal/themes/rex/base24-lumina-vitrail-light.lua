-- vim: ft=lua
-- Lumina Vitrail Light theme for Rex
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

local name = "base24-lumina-vitrail-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-vitrail-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Vitrail Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fcfaf4
palette = 1=#752200
palette = 2=#00490f
palette = 3=#7c4700
palette = 4=#1729b2
palette = 5=#49318e
palette = 6=#005b72
palette = 7=#0f141d
palette = 8=#dad7cf
palette = 9=#581700
palette = 10=#003408
palette = 11=#623700
palette = 12=#12247b
palette = 13=#480d5e
palette = 14=#004659
palette = 15=#0f141d
palette = 16=#4c1f00
palette = 17=#62127e
palette = 18=#f6f3eb
palette = 19=#eae8df
palette = 20=#89867f
palette = 21=#4a4841

# Foreground & background colors
background = #fcfaf4
foreground = #0f141d
cursor-color = #0f141d
selection-background = #0f141d
selection-foreground = #eae8df
search-background = #7c4700
search-foreground = #f6f3eb
search-selected-background = #4c1f00
search-selected-foreground = #f6f3eb

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #0f141d
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #12247b
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
