-- vim: ft=lua
-- Madrid theme for Rex
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

local name = "base16-madrid"
local variant = "light"

-- This must match themes/ghostty/base16-madrid exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Madrid theme for Ghostty
# Scheme Author: xscriptor (https://github.com/xscriptor)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fafafa
palette = 1=#990026
palette = 2=#007a28
palette = 3=#8a6408
palette = 4=#007a9e
palette = 5=#4d2699
palette = 6=#007a9e
palette = 7=#1a1a1a
palette = 8=#4d4d4d
palette = 9=#990026
palette = 10=#007a28
palette = 11=#8a6408
palette = 12=#007a9e
palette = 13=#4d2699
palette = 14=#007a9e
palette = 15=#1a1a1a
palette = 16=#923217
palette = 17=#662310
palette = 18=#eaeaea
palette = 19=#dfdfdf
palette = 20=#686868
palette = 21=#121212

# Foreground & background colors
background = #fafafa
foreground = #1a1a1a
cursor-color = #1a1a1a
selection-background = #1a1a1a
selection-foreground = #dfdfdf
search-background = #8a6408
search-foreground = #1a1a1a
search-selected-background = #923217
search-selected-foreground = #1a1a1a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1a1a1a
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #007a9e
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
