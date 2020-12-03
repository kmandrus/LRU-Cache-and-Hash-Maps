require 'byebug'

class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  attr_accessor :count
  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
    @start_idx = capacity / 2
  end

  def [](i) 
    return nil if i >= count || i < -count
    @store[ring_idx(i)]
  end

  def []=(i, val)
    validate!(i)
    resize! until capacity > i
    @count = i + 1 if i > count
    @store[ring_idx(i)] = val
  end

  def capacity
    @store.length
  end

  def push(val)
    resize! if resize_needed?
    @store[ring_idx(count)] = val
    @count += 1
  end

  def unshift(val)
    resize! if resize_needed?
    @start_idx = ring_add(@start_idx, -1)
    @store[start_idx] = val
    @count += 1
  end

  def pop
    return nil if empty?
    last_element = last
    @store[end_idx] = nil
    @count -= 1
    last_element
  end

  def shift
    return nil if empty?
    first_ele = first
    @store[@start_idx] = nil
    @count -= 1
    @start_idx = ring_add(@start_idx, 1)
    first_ele
  end

  def first
    empty? ? nil : @store[@start_idx]
  end

  def last
    empty? ? nil : @store[end_idx]
  end

  def empty?
    count == 0
  end
  def full?
    count == capacity
  end

  def each(&prc)
    i = start_idx
    until i == end_idx
      prc.call(@store[i])
      i = ring_add(i, 1)
    end
    prc.call(@store[end_idx])
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless size == other.size
    (0...count).each { |i| return false unless self[i] == other[i] }
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private
  attr_accessor :start_idx

  def end_idx
    return start_idx if empty?
    ring_add(start_idx, count, -1)
  end

  def ring_idx(i)
    validate!(i)
    return start_idx if i == 0
    if negative_index?(i)
      ring_add(start_idx, (i % count))
    else
      ring_add(start_idx, i)
    end
  end

  def negative_index?(i)
    i < 0 && i >= -count
  end

  def validate!(i)
    raise "Out of Bounds" if i < -count
  end

  def resize!
    new_store = StaticArray.new(capacity * 2)
    new_start_idx = new_store.length / 2
    i = new_start_idx
    each do |ele|
      new_store[i] = ele
      i = (i + 1) % new_store.length
    end
    @start_idx = new_start_idx
    @store = new_store
  end

  def resize_needed?
    count == capacity
  end

  def ring_add(*vals)
    vals.sum % capacity
  end
end
