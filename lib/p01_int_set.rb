class MaxIntSet
  attr_reader :store
  def initialize(max)
    @max = max
    @store = Array.new(@max, false)
  end

  def insert(num)
    validate!(num)
    @store[num] = true
  end

  def remove(num)
    validate!(num)
    @store[num] = false
  end

  def include?(num)
    validate!(num)
    @store[num]
  end

  private

  def is_valid?(num)
    num >= 0 && num < @max
  end

  def validate!(num)
    raise "Out of bounds" unless is_valid?(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    self[num] << num unless self[num].include?(num)
  end

  def remove(num)
    self[num].delete(num)
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    resize! if need_resize_up?
    unless include?(num)
      self[num] << num
      @count += 1
    end
  end

  def remove(num)
    @count -= 1 if self[num].delete(num)
    shrink! if need_resize_down?
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    nums = @store.flatten
    @count = 0
    @store = Array.new(num_buckets * 2) { Array.new }
    nums.each { |num| insert(num) }
  end

  def shrink!
    nums = @store.flatten
    @count = 0
    @store = Array.new(num_buckets / 2) { Array.new }
    nums.each { |num| insert(num) }
  end

  def need_resize_up?
    count + 1 >= num_buckets
  end

  def need_resize_down?
    count <= (num_buckets / 3) && count > 20
  end
end
