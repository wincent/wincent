-- vim: ft=lua
-- Da One Ocean theme for Rex
-- Scheme Author: NNB (https://github.com/NNBnh)
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

local name = "base16-da-one-ocean"
local variant = "dark"

-- This must match themes/ghostty/base16-da-one-ocean exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Da One Ocean theme for Ghostty
# Scheme Author: NNB (https://github.com/NNBnh)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#171726
palette = 1=#fa7883
palette = 2=#98c379
palette = 3=#ff9470
palette = 4=#6bb8ff
palette = 5=#e799ff
palette = 6=#8af5ff
palette = 7=#ffffff
palette = 8=#878d96
palette = 9=#fa7883
palette = 10=#98c379
palette = 11=#ff9470
palette = 12=#6bb8ff
palette = 13=#e799ff
palette = 14=#8af5ff
palette = 15=#ffffff
palette = 16=#ffc387
palette = 17=#b3684f
palette = 18=#22273d
palette = 19=#525866
palette = 20=#c8c8c8
palette = 21=#ffffff

# Foreground & background colors
background = #171726
foreground = #ffffff
cursor-color = #ffffff
selection-background = #ffffff
selection-foreground = #525866
search-background = #ff9470
search-foreground = #22273d
search-selected-background = #ffc387
search-selected-foreground = #22273d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6bb8ff
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
