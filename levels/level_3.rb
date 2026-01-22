require 'ruby2d'
require_relative '../wall'

class Level3
  attr_reader :walls, :finish, :start_x, :start_y

  def initialize
    @start_x = 50
    @start_y = 380

    @walls = [
      Wall.new(x: 0, y: 250, width: 700, height: 100),
      Wall.new(x: 200, y: 350, width: 100, height: 350),
      Wall.new(x: 200, y: 800, width: 100, height: 100),
      Wall.new(x: 400, y: 450, width: 100, height: 400),
      Wall.new(x: 600, y: 350, width: 100, height: 350),
      Wall.new(x: 600, y: 800, width: 100, height: 100),
      Wall.new(x: 800, y: 150, width: 100, height: 700),
      Wall.new(x: 100, y: 125, width: 800, height: 25),
      Wall.new(x: 0, y: 0, width: 900, height: 25),



    ]

    @finish = Image.new(
      'img/biggie.jpeg',
      x: 1115,
      y: 380,
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
