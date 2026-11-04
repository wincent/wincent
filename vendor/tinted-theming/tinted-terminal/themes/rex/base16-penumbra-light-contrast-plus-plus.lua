-- vim: ft=lua
-- Penumbra Light Contrast Plus Plus theme for Rex
-- Scheme Author: Zachary Weiss (https://github.com/zacharyweiss)
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

local name = "base16-penumbra-light-contrast-plus-plus"
local variant = "light"

-- This must match themes/ghostty/base16-penumbra-light-contrast-plus-plus exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Penumbra Light Contrast Plus Plus theme for Ghostty
# Scheme Author: Zachary Weiss (https://github.com/zacharyweiss)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fffdfb
palette = 1=#f58c81
palette = 2=#54c794
palette = 3=#a9b852
palette = 4=#6eb2fd
palette = 5=#b69cf6
palette = 6=#00c4d7
palette = 7=#636363
palette = 8=#dedede
palette = 9=#f58c81
palette = 10=#54c794
palette = 11=#a9b852
palette = 12=#6eb2fd
palette = 13=#b69cf6
palette = 14=#00c4d7
palette = 15=#0d0f13
palette = 16=#e09f47
palette = 17=#e58cc5
palette = 18=#fff7ed
palette = 19=#f2e6d4
palette = 20=#aeaeae
palette = 21=#181b1f

# Foreground & background colors
background = #fffdfb
foreground = #636363
cursor-color = #636363
selection-background = #636363
selection-foreground = #f2e6d4
search-background = #a9b852
search-foreground = #0d0f13
search-selected-background = #e09f47
search-selected-foreground = #0d0f13

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #0d0f13
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6eb2fd
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
