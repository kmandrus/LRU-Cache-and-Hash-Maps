require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    calc!(key) unless @map.include?(key)
    node = @map[key]
    update_node!(node)
    return node.val
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    node = @store.append(key, @prc.call(key))
    @map.set(key, node)
    eject! if count > @max
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    node.remove
    @map.delete(node.key)
    new_node = @store.append(node.key, node.val)
    @map.set(node.key, new_node)
  end

  def eject!
    node = @store.first.remove
    @map.delete(node.key)
  end
end
