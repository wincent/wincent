-- vim: ft=lua
-- Solarized Dark Patched theme for Rex
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

local name = "base24-solarized-dark-patched"
local variant = "dark"

-- This must match themes/ghostty/base24-solarized-dark-patched exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Solarized Dark Patched theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#001e26
palette = 1=#d01b24
palette = 2=#728905
palette = 3=#708183
palette = 4=#2075c7
palette = 5=#c61b6e
palette = 6=#259185
palette = 7=#c0c0b0
palette = 8=#6e7c7b
palette = 9=#bd3612
palette = 10=#465a61
palette = 11=#52676f
palette = 12=#708183
palette = 13=#5856b9
palette = 14=#81908f
palette = 15=#fcf4dc
palette = 16=#a57705
palette = 17=#680d12
palette = 18=#002731
palette = 19=#465a61
palette = 20=#979e96
palette = 21=#e9e2cb

# Foreground & background colors
background = #001e26
foreground = #c0c0b0
cursor-color = #c0c0b0
selection-background = #c0c0b0
selection-foreground = #465a61
search-background = #708183
search-foreground = #002731
search-selected-background = #a57705
search-selected-foreground = #002731

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fcf4dc
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #708183
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
