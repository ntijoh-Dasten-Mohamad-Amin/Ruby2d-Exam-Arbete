require 'ruby2d'
require_relative '../wall'

class Level3
  attr_reader :walls, :finish, :start_x, :start_y

  def initialize
    @start_x = 50
    @start_y = 425

    @walls = [
      Wall.new(x: 500, y: 100, width: 100, height: 300),
    ]

    @finish = Image.new(
      'img/biggie.jpeg',
      x: 1115,
      y: 425,
      width: 85,
      height: 85
    )
  end

  def add
    @walls.each(&:add)
    @finish.add
  end

  def remove
    @walls.each(&:remove)
    @finish.remove
  end
end
