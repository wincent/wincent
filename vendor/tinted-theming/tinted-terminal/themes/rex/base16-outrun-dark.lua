-- vim: ft=lua
-- Outrun Dark theme for Rex
-- Scheme Author: Hugo Delahousse (http://github.com/hugodelahousse/)
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

local name = "base16-outrun-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-outrun-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Outrun Dark theme for Ghostty
# Scheme Author: Hugo Delahousse (http://github.com/hugodelahousse/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#00002a
palette = 1=#ff4242
palette = 2=#59f176
palette = 3=#f3e877
palette = 4=#66b0ff
palette = 5=#f10596
palette = 6=#0ef0f0
palette = 7=#d0d0fa
palette = 8=#50507a
palette = 9=#ff4242
palette = 10=#59f176
palette = 11=#f3e877
palette = 12=#66b0ff
palette = 13=#f10596
palette = 14=#0ef0f0
palette = 15=#f5f5ff
palette = 16=#fc8d28
palette = 17=#f003ef
palette = 18=#20204a
palette = 19=#30305a
palette = 20=#b0b0da
palette = 21=#e0e0ff

# Foreground & background colors
background = #00002a
foreground = #d0d0fa
cursor-color = #d0d0fa
selection-background = #d0d0fa
selection-foreground = #30305a
search-background = #f3e877
search-foreground = #20204a
search-selected-background = #fc8d28
search-selected-foreground = #20204a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f5f5ff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #66b0ff
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
