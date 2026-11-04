-- vim: ft=lua
-- IC-Orange-PPL theme for Rex
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

local name = "base24-ic-orange-ppl"
local variant = "dark"

-- This must match themes/ghostty/base24-ic-orange-ppl exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# IC-Orange-PPL theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#262626
palette = 1=#c03900
palette = 2=#a3a900
palette = 3=#ffbd54
palette = 4=#bd6c00
palette = 5=#fb5d00
palette = 6=#f79400
palette = 7=#d9a971
palette = 8=#8f6c41
palette = 9=#ff8b67
palette = 10=#f6ff3f
palette = 11=#ffe36e
palette = 12=#ffbd54
palette = 13=#fc874f
palette = 14=#c59752
palette = 15=#f9f9fe
palette = 16=#caae00
palette = 17=#601c00
palette = 18=#000000
palette = 19=#6a4e29
palette = 20=#b48b59
palette = 21=#ffc88a

# Foreground & background colors
background = #262626
foreground = #d9a971
cursor-color = #d9a971
selection-background = #d9a971
selection-foreground = #6a4e29
search-background = #ffbd54
search-foreground = #000000
search-selected-background = #caae00
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f9f9fe
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #ffbd54
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
