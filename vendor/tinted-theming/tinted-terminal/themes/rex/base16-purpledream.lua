-- vim: ft=lua
-- Purpledream theme for Rex
-- Scheme Author: malet
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

local name = "base16-purpledream"
local variant = "dark"

-- This must match themes/ghostty/base16-purpledream exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Purpledream theme for Ghostty
# Scheme Author: malet
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#100510
palette = 1=#ff1d0d
palette = 2=#14cc64
palette = 3=#f000a0
palette = 4=#00a0f0
palette = 5=#b000d0
palette = 6=#0075b0
palette = 7=#ddd0dd
palette = 8=#605060
palette = 9=#ff1d0d
palette = 10=#14cc64
palette = 11=#f000a0
palette = 12=#00a0f0
palette = 13=#b000d0
palette = 14=#0075b0
palette = 15=#fff0ff
palette = 16=#ccae14
palette = 17=#6a2a3c
palette = 18=#302030
palette = 19=#403040
palette = 20=#bbb0bb
palette = 21=#eee0ee

# Foreground & background colors
background = #100510
foreground = #ddd0dd
cursor-color = #ddd0dd
selection-background = #ddd0dd
selection-foreground = #403040
search-background = #f000a0
search-foreground = #302030
search-selected-background = #ccae14
search-selected-foreground = #302030

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fff0ff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #00a0f0
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
