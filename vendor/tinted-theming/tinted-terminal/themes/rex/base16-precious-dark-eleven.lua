-- vim: ft=lua
-- Precious Dark Eleven theme for Rex
-- Scheme Author: 4lex4 &lt;4lex49@zoho.com&gt;
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

local name = "base16-precious-dark-eleven"
local variant = "dark"

-- This must match themes/ghostty/base16-precious-dark-eleven exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Precious Dark Eleven theme for Ghostty
# Scheme Author: 4lex4 &lt;4lex49@zoho.com&gt;
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c1e20
palette = 1=#ff8782
palette = 2=#95b658
palette = 3=#d0a543
palette = 4=#68b0ee
palette = 5=#b799fe
palette = 6=#42bda7
palette = 7=#b8b7b6
palette = 8=#858585
palette = 9=#ff8782
palette = 10=#95b658
palette = 11=#d0a543
palette = 12=#68b0ee
palette = 13=#b799fe
palette = 14=#42bda7
palette = 15=#b8b7b6
palette = 16=#ea9755
palette = 17=#f382d8
palette = 18=#292b2d
palette = 19=#37393a
palette = 20=#a8a8a7
palette = 21=#b8b7b6

# Foreground & background colors
background = #1c1e20
foreground = #b8b7b6
cursor-color = #b8b7b6
selection-background = #b8b7b6
selection-foreground = #37393a
search-background = #d0a543
search-foreground = #292b2d
search-selected-background = #ea9755
search-selected-foreground = #292b2d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #b8b7b6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #68b0ee
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
