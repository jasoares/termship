class Termship::Ship
  attr_reader :name, :size, :hits

  def initialize(name, size)
    @name = name
    @size = size
    @hits = 0
  end

  def hit!
    @hits += 1
    self
  end

  def sunk?
    @hits >= @size
  end

  def to_s
    "#{@name} (Size: #{@size}, Hits: #{@hits}) #{sunk? ? 'sunk!' : ''}"
  end
end
