--
-- FIFO queue implemented as linked list.
--

return {
  create = (function()
    local head = nil
    local tail = nil
    local length = 0
    return setmetatable({
      enqueue = (function(item)
        new = {item = item}
        if tail then
          tail.next = new
        else
          head = new
          tail = new
        end
        length = length + 1
      end),
      dequeue = (function()
        length = length - 1
        if head then
          item = head.item
          if head == tail then
            tail = nil
          end
          head = head.next
          return item
        else
          return nil
        end
      end),
      pet
    }, {
      __index = (function(t, k)
        if k == 'length' then
          return length
        else
          return nil
        end
      end),
    })
  end),
}
