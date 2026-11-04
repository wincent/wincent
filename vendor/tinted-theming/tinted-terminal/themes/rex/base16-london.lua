-- vim: ft=lua
-- London theme for Rex
-- Scheme Author: xscriptor (https://github.com/xscriptor)
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

local name = "base16-london"
local variant = "light"

-- This must match themes/ghostty/base16-london exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# London theme for Ghostty
# Scheme Author: xscriptor (https://github.com/xscriptor)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#333333
palette = 2=#444444
palette = 3=#555555
palette = 4=#666666
palette = 5=#777777
palette = 6=#888888
palette = 7=#333333
palette = 8=#333333
palette = 9=#333333
palette = 10=#444444
palette = 11=#555555
palette = 12=#666666
palette = 13=#777777
palette = 14=#888888
palette = 15=#aaaaaa
palette = 16=#444444
palette = 17=#303030
palette = 18=#f1f1f1
palette = 19=#e7e7e7
palette = 20=#7a7a7a
palette = 21=#242424

# Foreground & background colors
background = #ffffff
foreground = #333333
cursor-color = #333333
selection-background = #333333
selection-foreground = #e7e7e7
search-background = #555555
search-foreground = #aaaaaa
search-selected-background = #444444
search-selected-foreground = #aaaaaa

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #aaaaaa
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #666666
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
