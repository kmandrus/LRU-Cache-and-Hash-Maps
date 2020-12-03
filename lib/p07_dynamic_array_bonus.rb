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
  end

  def [](i)
    return nil if i >= count || i < -count
    return @store[i % count] if i < 0 && i >= -count
    @store[i]
  end

  def []=(i, val)
    resize! until capacity > i if i >= capacity
    @count = i + 1 if i > count
    raise "Out of Bounds" if i < -count
    if i < 0 && i >= -count
      @store[i % count] = val 
    else
      @store[i] = val
    end
  end

  def capacity
    @store.length
  end

  def include?(val)
    any? { |ele| ele == val }
  end

  def push(val)
    resize! if resize_needed?
    @store[count] = val
    @count += 1
  end

  def unshift(val)
    resize! if resize_needed?
    i = count
    while i > 0
      @store[i] = @store[i-1]
      i -= 1
    end
    @store[0] = val
    @count += 1
  end

  def pop
    return nil if empty?
    ele = last
    @count -= 1
    @store[count] = nil
    ele
  end

  def shift
    return nil if empty?
    ele = first
    @count -= 1
    (0...count).each { |i| @store[i] = @store[i+1] }
    @store[count] = nil
    ele
  end

  def first
    empty? ? nil : @store[0]
  end

  def last
    empty? ? nil : @store[count - 1]
  end

  def empty?
    count == 0
  end

  def each(&prc)
    (0...count).each { |i| prc.call(@store[i]) }
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

  def resize!
    new_store = StaticArray.new(capacity * 2)
    (0...count).each do |i|
      new_store[i] = @store[i]
    end
    @store = new_store
  end

  def resize_needed?
    count == capacity
  end
end
