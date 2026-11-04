-- vim: ft=lua
-- Monokai Vivid theme for Rex
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

local name = "base24-monokai-vivid"
local variant = "dark"

-- This must match themes/ghostty/base24-monokai-vivid exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Monokai Vivid theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#121212
palette = 1=#fa2834
palette = 2=#97e123
palette = 3=#fef20a
palette = 4=#0442fe
palette = 5=#f800f8
palette = 6=#01b6ed
palette = 7=#dfdfdf
palette = 8=#525252
palette = 9=#f5669c
palette = 10=#b0e05e
palette = 11=#fef26c
palette = 12=#0442fe
palette = 13=#f200f5
palette = 14=#50cdfe
palette = 15=#ffffff
palette = 16=#fec50a
palette = 17=#7d141a
palette = 18=#323232
palette = 19=#424242
palette = 20=#c0c0c0
palette = 21=#f1f1f1

# Foreground & background colors
background = #121212
foreground = #dfdfdf
cursor-color = #dfdfdf
selection-background = #dfdfdf
selection-foreground = #424242
search-background = #fef20a
search-foreground = #323232
search-selected-background = #fec50a
search-selected-foreground = #323232

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0442fe
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
