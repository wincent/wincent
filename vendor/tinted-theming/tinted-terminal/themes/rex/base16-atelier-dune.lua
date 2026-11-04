-- vim: ft=lua
-- Atelier Dune theme for Rex
-- Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
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

local name = "base16-atelier-dune"
local variant = "dark"

-- This must match themes/ghostty/base16-atelier-dune exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Dune theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#20201d
palette = 1=#d73737
palette = 2=#60ac39
palette = 3=#ae9513
palette = 4=#6684e1
palette = 5=#b854d4
palette = 6=#1fad83
palette = 7=#a6a28c
palette = 8=#7d7a68
palette = 9=#d73737
palette = 10=#60ac39
palette = 11=#ae9513
palette = 12=#6684e1
palette = 13=#b854d4
palette = 14=#1fad83
palette = 15=#fefbec
palette = 16=#b65611
palette = 17=#d43552
palette = 18=#292824
palette = 19=#6e6b5e
palette = 20=#999580
palette = 21=#e8e4cf

# Foreground & background colors
background = #20201d
foreground = #a6a28c
cursor-color = #a6a28c
selection-background = #a6a28c
selection-foreground = #6e6b5e
search-background = #ae9513
search-foreground = #292824
search-selected-background = #b65611
search-selected-foreground = #292824

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fefbec
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6684e1
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
