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
        if head then
          length = length - 1
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
      __len = (function(t)
        return length
      end),
    })
  end),
}
