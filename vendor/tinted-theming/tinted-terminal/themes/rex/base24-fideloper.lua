-- vim: ft=lua
-- Fideloper theme for Rex
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

local name = "base24-fideloper"
local variant = "dark"

-- This must match themes/ghostty/base24-fideloper exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Fideloper theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#282f32
palette = 1=#ca1d2c
palette = 2=#edb7ab
palette = 3=#7c84c4
palette = 4=#2e78c1
palette = 5=#c0226e
palette = 6=#309185
palette = 7=#b1b1a3
palette = 8=#415050
palette = 9=#d35f5a
palette = 10=#d35f5a
palette = 11=#a86571
palette = 12=#7c84c4
palette = 13=#5b5db2
palette = 14=#81908f
palette = 15=#fcf4de
palette = 16=#b7aa9a
palette = 17=#650e16
palette = 18=#282f32
palette = 19=#092027
palette = 20=#79817a
palette = 21=#e9e2cd

# Foreground & background colors
background = #282f32
foreground = #b1b1a3
cursor-color = #b1b1a3
selection-background = #b1b1a3
selection-foreground = #092027
search-background = #7c84c4
search-foreground = #282f32
search-selected-background = #b7aa9a
search-selected-foreground = #282f32

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fcf4de
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7c84c4
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
