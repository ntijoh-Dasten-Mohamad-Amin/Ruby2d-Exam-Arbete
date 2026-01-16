require 'ruby2d'
require_relative '../wall'

class Level2
  attr_reader :walls, :finish, :start_x, :start_y

  def initialize
    @start_x = 50
    @start_y = 380

    @walls = [
      Wall.new(x: 0, y: 175, width: 450, height: 100),
      Wall.new(x: 0, y: 555, width: 450, height: 100),
      Wall.new(x: 350, y: 370, width: 90, height: 90),
      Wall.new(x: 600, y: 150, width: 100, height: 550),
      Wall.new(x: 600, y: 0, width: 100, height: 50),
      Wall.new(x: 600, y: 800, width: 100, height: 50),

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
