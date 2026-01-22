require 'ruby2d'
require_relative '../wall'

class Level1
  attr_reader :walls, :finish, :start_x, :start_y

  def initialize
    @start_x = 50
    @start_y = 380

    @walls = [
      Wall.new(x: 190, y: 280, width: 100, height: 300),
      Wall.new(x: 415, y: 0, width: 100, height: 300),
      Wall.new(x: 415, y: 550, width: 100, height: 300),
      Wall.new(x: 640, y: 230, width: 100, height: 410),


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
