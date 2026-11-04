-- vim: ft=lua
-- Helios theme for Rex
-- Scheme Author: Alex Meyer (https://github.com/reyemxela)
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

local name = "base16-helios"
local variant = "dark"

-- This must match themes/ghostty/base16-helios exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Helios theme for Ghostty
# Scheme Author: Alex Meyer (https://github.com/reyemxela)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1d2021
palette = 1=#d72638
palette = 2=#88b92d
palette = 3=#f19d1a
palette = 4=#1e8bac
palette = 5=#be4264
palette = 6=#1ba595
palette = 7=#d5d5d5
palette = 8=#6f7579
palette = 9=#d72638
palette = 10=#88b92d
palette = 11=#f19d1a
palette = 12=#1e8bac
palette = 13=#be4264
palette = 14=#1ba595
palette = 15=#e5e5e5
palette = 16=#eb8413
palette = 17=#c85e0d
palette = 18=#383c3e
palette = 19=#53585b
palette = 20=#cdcdcd
palette = 21=#dddddd

# Foreground & background colors
background = #1d2021
foreground = #d5d5d5
cursor-color = #d5d5d5
selection-background = #d5d5d5
selection-foreground = #53585b
search-background = #f19d1a
search-foreground = #383c3e
search-selected-background = #eb8413
search-selected-foreground = #383c3e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e5e5e5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1e8bac
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
