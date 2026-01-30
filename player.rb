class Player
  attr_reader :shape
  attr_accessor :x_speed, :y_speed

  def initialize(x:, y:, size:)
    @size = size
    @shape = Rectangle.new(
      x: x,
      y: y,
      width: size,
      height: size,
      color: 'yellow'
    )
    @shape.remove
    @y_speed = 0
  end

  def add
    @shape.add
  end

  def remove
    @shape.remove
  end

  def move
    @shape.x += @x_speed
    @shape.y += @y_speed
  end

  def size
    @size
  end
end
