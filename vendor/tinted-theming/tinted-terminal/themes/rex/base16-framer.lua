-- vim: ft=lua
-- Framer theme for Rex
-- Scheme Author: Framer (Maintained by Jesse Hoyos)
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

local name = "base16-framer"
local variant = "dark"

-- This must match themes/ghostty/base16-framer exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Framer theme for Ghostty
# Scheme Author: Framer (Maintained by Jesse Hoyos)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#181818
palette = 1=#fd886b
palette = 2=#32ccdc
palette = 3=#fecb6e
palette = 4=#20bcfc
palette = 5=#ba8cfc
palette = 6=#acddfd
palette = 7=#d0d0d0
palette = 8=#747474
palette = 9=#fd886b
palette = 10=#32ccdc
palette = 11=#fecb6e
palette = 12=#20bcfc
palette = 13=#ba8cfc
palette = 14=#acddfd
palette = 15=#eeeeee
palette = 16=#fc4769
palette = 17=#b15f4a
palette = 18=#151515
palette = 19=#464646
palette = 20=#b9b9b9
palette = 21=#e8e8e8

# Foreground & background colors
background = #181818
foreground = #d0d0d0
cursor-color = #d0d0d0
selection-background = #d0d0d0
selection-foreground = #464646
search-background = #fecb6e
search-foreground = #151515
search-selected-background = #fc4769
search-selected-foreground = #151515

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #eeeeee
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #20bcfc
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
