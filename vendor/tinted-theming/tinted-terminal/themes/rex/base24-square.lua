-- vim: ft=lua
-- Square theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-square"
local variant = "dark"

-- This must match themes/ghostty/base24-square exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Square theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1a1a1a
palette = 1=#e9897c
palette = 2=#b6377d
palette = 3=#b6defb
palette = 4=#a9cdeb
palette = 5=#75507b
palette = 6=#c9caec
palette = 7=#bababa
palette = 8=#4b4b4b
palette = 9=#f99286
palette = 10=#c3f786
palette = 11=#fcfbcc
palette = 12=#b6defb
palette = 13=#ad7fa8
palette = 14=#d7d9fc
palette = 15=#e2e2e2
palette = 16=#ecebbe
palette = 17=#74443e
palette = 18=#050505
palette = 19=#141414
palette = 20=#838383
palette = 21=#f2f2f2

# Foreground & background colors
background = #1a1a1a
foreground = #bababa
cursor-color = #bababa
selection-background = #bababa
selection-foreground = #141414
search-background = #b6defb
search-foreground = #050505
search-selected-background = #ecebbe
search-selected-foreground = #050505

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e2e2e2
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b6defb
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
