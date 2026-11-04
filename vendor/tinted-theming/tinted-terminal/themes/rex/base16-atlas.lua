-- vim: ft=lua
-- Atlas theme for Rex
-- Scheme Author: Alex Lende (https://ajlende.com)
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

local name = "base16-atlas"
local variant = "dark"

-- This must match themes/ghostty/base16-atlas exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atlas theme for Ghostty
# Scheme Author: Alex Lende (https://ajlende.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#002635
palette = 1=#ff5a67
palette = 2=#7fc06e
palette = 3=#ffcc1b
palette = 4=#14747e
palette = 5=#9a70a4
palette = 6=#5dd7b9
palette = 7=#a1a19a
palette = 8=#6c8b91
palette = 9=#ff5a67
palette = 10=#7fc06e
palette = 11=#ffcc1b
palette = 12=#14747e
palette = 13=#9a70a4
palette = 14=#5dd7b9
palette = 15=#fafaf8
palette = 16=#f08e48
palette = 17=#c43060
palette = 18=#00384d
palette = 19=#517f8d
palette = 20=#869696
palette = 21=#e6e6dc

# Foreground & background colors
background = #002635
foreground = #a1a19a
cursor-color = #a1a19a
selection-background = #a1a19a
selection-foreground = #517f8d
search-background = #ffcc1b
search-foreground = #00384d
search-selected-background = #f08e48
search-selected-foreground = #00384d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fafaf8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #14747e
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
