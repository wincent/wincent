-- vim: ft=lua
-- Bogota theme for Rex
-- Scheme Author: xscriptor (https://github.com/xscriptor)
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

local name = "base24-bogota"
local variant = "dark"

-- This must match themes/ghostty/base24-bogota exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Bogota theme for Ghostty
# Scheme Author: xscriptor (https://github.com/xscriptor)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#200b0a
palette = 1=#fc618d
palette = 2=#7bd88f
palette = 3=#ffed89
palette = 4=#47e6ff
palette = 5=#ff9999
palette = 6=#47e6ff
palette = 7=#f7f1ff
palette = 8=#525053
palette = 9=#fc618d
palette = 10=#7bd88f
palette = 11=#ffed89
palette = 12=#47e6ff
palette = 13=#ff9999
palette = 14=#47e6ff
palette = 15=#f7f1ff
palette = 16=#fea78b
palette = 17=#b0705e
palette = 18=#2f1b1b
palette = 19=#3a2727
palette = 20=#968a91
palette = 21=#f9f4ff

# Foreground & background colors
background = #200b0a
foreground = #f7f1ff
cursor-color = #f7f1ff
selection-background = #f7f1ff
selection-foreground = #3a2727
search-background = #ffed89
search-foreground = #2f1b1b
search-selected-background = #fea78b
search-selected-foreground = #2f1b1b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f7f1ff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #47e6ff
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
