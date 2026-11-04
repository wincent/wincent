-- vim: ft=lua
-- 0x96f theme for Rex
-- Scheme Author: Filip Janevski (https://0x96f.dev/theme)
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

local name = "base24-0x96f"
local variant = "dark"

-- This must match themes/ghostty/base24-0x96f exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# 0x96f theme for Ghostty
# Scheme Author: Filip Janevski (https://0x96f.dev/theme)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#262427
palette = 1=#ff7272
palette = 2=#bcdf59
palette = 3=#ffca58
palette = 4=#49cae4
palette = 5=#a093e2
palette = 6=#aee8f4
palette = 7=#fcfcfc
palette = 8=#676567
palette = 9=#ff8787
palette = 10=#c6e472
palette = 11=#ffd271
palette = 12=#64d2e8
palette = 13=#aea3e6
palette = 14=#baebf6
palette = 15=#fcfcfc
palette = 16=#fc9d6f
palette = 17=#ff8787
palette = 18=#3b393c
palette = 19=#514f52
palette = 20=#7c7b7d
palette = 21=#eae9eb

# Foreground & background colors
background = #262427
foreground = #fcfcfc
cursor-color = #fcfcfc
selection-background = #fcfcfc
selection-foreground = #514f52
search-background = #ffca58
search-foreground = #3b393c
search-selected-background = #fc9d6f
search-selected-foreground = #3b393c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fcfcfc
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #64d2e8
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
