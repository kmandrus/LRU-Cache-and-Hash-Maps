class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    diff = self.first.hash
    self.each_with_index do |int, i|
      if i > 0
        diff -=  int.hash
      end
    end
    diff
  end
end

class String
  def hash
    chars_to_ints = {}
    ('a'..'z').to_a.each_with_index do |char, i|
      chars_to_ints[char] = (i+1)
    end
    self.split('').map { |char| chars_to_ints[char] }.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    self.to_a.sort.flatten.hash
  end
end
