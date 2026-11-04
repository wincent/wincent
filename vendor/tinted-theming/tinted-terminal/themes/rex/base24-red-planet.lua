-- vim: ft=lua
-- Red Planet theme for Rex
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

local name = "base24-red-planet"
local variant = "dark"

-- This must match themes/ghostty/base24-red-planet exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Red Planet theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#222222
palette = 1=#8c3432
palette = 2=#728271
palette = 3=#60827e
palette = 4=#69809e
palette = 5=#896492
palette = 6=#5b8390
palette = 7=#a4998c
palette = 8=#7b7773
palette = 9=#b55242
palette = 10=#869985
palette = 11=#ebeb91
palette = 12=#60827e
palette = 13=#de4873
palette = 14=#38add8
palette = 15=#d6bfb8
palette = 16=#e8bf6a
palette = 17=#461a19
palette = 18=#201f1f
palette = 19=#676767
palette = 20=#908880
palette = 21=#b9aa99

# Foreground & background colors
background = #222222
foreground = #a4998c
cursor-color = #a4998c
selection-background = #a4998c
selection-foreground = #676767
search-background = #60827e
search-foreground = #201f1f
search-selected-background = #e8bf6a
search-selected-foreground = #201f1f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d6bfb8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #60827e
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
