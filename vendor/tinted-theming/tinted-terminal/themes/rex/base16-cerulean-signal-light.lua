-- vim: ft=lua
-- Cerulean Signal Light theme for Rex
-- Scheme Author: Aaron Colichia (https://aaron.colichia.org/)
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

local name = "base16-cerulean-signal-light"
local variant = "light"

-- This must match themes/ghostty/base16-cerulean-signal-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Cerulean Signal Light theme for Ghostty
# Scheme Author: Aaron Colichia (https://aaron.colichia.org/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f7f9fc
palette = 1=#b4233d
palette = 2=#17795e
palette = 3=#6f6300
palette = 4=#006fa8
palette = 5=#a0007d
palette = 6=#00727e
palette = 7=#232b38
palette = 8=#637287
palette = 9=#b4233d
palette = 10=#17795e
palette = 11=#6f6300
palette = 12=#006fa8
palette = 13=#a0007d
palette = 14=#00727e
palette = 15=#141d2a
palette = 16=#9a4f00
palette = 17=#7a4e3c
palette = 18=#eef4fb
palette = 19=#dde7f1
palette = 20=#566579
palette = 21=#202b3a

# Foreground & background colors
background = #f7f9fc
foreground = #232b38
cursor-color = #232b38
selection-background = #232b38
selection-foreground = #dde7f1
search-background = #6f6300
search-foreground = #141d2a
search-selected-background = #9a4f00
search-selected-foreground = #141d2a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #141d2a
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #006fa8
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
