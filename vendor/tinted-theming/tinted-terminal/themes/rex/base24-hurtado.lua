-- vim: ft=lua
-- Hurtado theme for Rex
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

local name = "base24-hurtado"
local variant = "dark"

-- This must match themes/ghostty/base24-hurtado exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Hurtado theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#000000
palette = 1=#ff1b00
palette = 2=#a5df55
palette = 3=#89bdff
palette = 4=#486387
palette = 5=#fc5ef0
palette = 6=#85e9fe
palette = 7=#a1a1a1
palette = 8=#4e4e4e
palette = 9=#d41c00
palette = 10=#a5df55
palette = 11=#fbe749
palette = 12=#89bdff
palette = 13=#bf00c0
palette = 14=#85e9fe
palette = 15=#dbdbdb
palette = 16=#fbe74a
palette = 17=#7f0d00
palette = 18=#575757
palette = 19=#252525
palette = 20=#787878
palette = 21=#cbcbcb

# Foreground & background colors
background = #000000
foreground = #a1a1a1
cursor-color = #a1a1a1
selection-background = #a1a1a1
selection-foreground = #252525
search-background = #89bdff
search-foreground = #575757
search-selected-background = #fbe74a
search-selected-foreground = #575757

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #dbdbdb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #89bdff
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
