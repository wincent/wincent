-- vim: ft=lua
-- Tokio theme for Rex
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

local name = "base24-tokio"
local variant = "dark"

-- This must match themes/ghostty/base24-tokio exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tokio theme for Ghostty
# Scheme Author: xscriptor (https://github.com/xscriptor)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c1c1d
palette = 1=#fc618d
palette = 2=#7bd88f
palette = 3=#fce566
palette = 4=#fd9353
palette = 5=#948ae3
palette = 6=#5ad4e6
palette = 7=#f7f1ff
palette = 8=#78757c
palette = 9=#fc618d
palette = 10=#7bd88f
palette = 11=#fce566
palette = 12=#fd9353
palette = 13=#948ae3
palette = 14=#5ad4e6
palette = 15=#f7f1ff
palette = 16=#fca37a
palette = 17=#ae7459
palette = 18=#2b2b2d
palette = 19=#363638
palette = 20=#949199
palette = 21=#f9f4ff

# Foreground & background colors
background = #1c1c1d
foreground = #f7f1ff
cursor-color = #f7f1ff
selection-background = #f7f1ff
selection-foreground = #363638
search-background = #fce566
search-foreground = #2b2b2d
search-selected-background = #fca37a
search-selected-foreground = #2b2b2d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f7f1ff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #fd9353
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
