require 'ruby2d'

class Player
  attr_reader :shape, :size
  attr_accessor :x_speed, :y_speed

  def initialize(x:, y:, size:)
    @size = size
    @x_speed = 0
    @y_speed = 0

    @shape = Square.new(
      x: x,
      y: y,
      size: size,
      color: 'yellow',
      z: 5
    )

    @added = false
  end

  # Add player to screen
  def add
    return if @added
    @shape.add
    @added = true
  end

  # Remove player from screen
  def remove
    return unless @added
    @shape.remove
    @added = false
  end

  # Movement logic
  def move
    @shape.x += @x_speed
    @shape.y += @y_speed
  end

  # Reset player position (for deaths / level start)
  def reset(x:, y:)
    @shape.x = x
    @shape.y = y
    @x_speed = 0
    @y_speed = 0
  end
end
