local lsocket = require 'lsocket'

local read_fd = {}

local m = {}

function m.read(fd, callback)
    if read_fd[fd] then
        table.remove(read_fd, read_fd[fd][2])
    end
    read_fd[#read_fd + 1] = fd
    read_fd[fd] = callback and { callback, #read_fd } or nil
end

function m.update()
    local res = lsocket.select(read_fd, 0.05)
    if res then
        for _, fd in ipairs(res) do
            local info = read_fd[fd]
            if info then
                info[1]()
            end
        end
    end
end

return m
