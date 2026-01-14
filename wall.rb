require 'ruby2d'

class Wall
  attr_reader :shape

  def initialize(x:, y:, width:, height:)
    @shape = Rectangle.new(
      x: x,
      y: y,
      width: width,
      height: height,
      color: 'red',
      z: 2
    )
  end

  def add
    @shape.add
  end

  def remove
    @shape.remove
  end

  def colliding?(player_shape, player_size)
    px = player_shape.x
    py = player_shape.y
    ps = player_size

    wx = @shape.x
    wy = @shape.y
    ww = @shape.width
    wh = @shape.height

    px < wx + ww &&
      px + ps > wx &&
      py < wy + wh &&
      py + ps > wy
  end
end
