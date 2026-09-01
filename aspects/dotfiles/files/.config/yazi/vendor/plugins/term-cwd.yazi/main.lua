--- @since 26.5.6

local function setup(_, opts)
    local target = ya.target_family()
    local default = target == "windows" and "OSC9_9" or "OSC7"
    local osc = opts and opts.osc or default

    local writers = {
        -- Recommended for unix
        OSC7 = function(cwd)
            -- Add starting slash on windows to separate the drive letter from hostname
            if target == "windows" then
                cwd = "/" .. cwd
            end
            io.write("\x1b]7;file://localhost" .. cwd .. "\x1b\\")
        end,
        -- Recommended for windows
        OSC9_9 = function(cwd)
            io.write("\x1b]9;9;" .. cwd .. "\x1b\\")
        end,
    }

    ps.sub("cd", function()
        local cwd = tostring(cx.active.current.cwd)
        local writeFn = writers[osc]
        if writeFn then
            writeFn(cwd)
            io.flush()
        end
    end)
end

return { setup = setup }
