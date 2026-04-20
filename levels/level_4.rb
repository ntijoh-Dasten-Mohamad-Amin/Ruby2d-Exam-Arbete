require 'ruby2d'
require_relative '../moving_object'

class Level4
  attr_reader :balls, :finish, :start_x, :start_y

  def initialize
    @start_x = 50
    @start_y = 380

    @radius_angry_balls = 10

    maxspeed = 6.0 #float
    minspeed = 5.0 #float

    #(x, y_speed, y, x_speed, game_status, radius_angry_balls)
    @balls = [
        Balls.new(100, rand(minspeed..maxspeed), 10, nil, @game_status, @radius_angry_balls),
        Balls.new(150, rand(-maxspeed..-minspeed), Window.height-10, nil, @game_status, @radius_angry_balls),
        Balls.new(200, rand(minspeed..maxspeed), 10, nil, @game_status, @radius_angry_balls),
        Balls.new(250, rand(-maxspeed..-minspeed), Window.height-10, nil, @game_status, @radius_angry_balls),
        Balls.new(300, rand(minspeed..maxspeed), 10, nil, @game_status, @radius_angry_balls),
        Balls.new(350, rand(-maxspeed..-minspeed), Window.height-10, nil, @game_status, @radius_angry_balls),
        Balls.new(400, rand(minspeed..maxspeed), 10, nil, @game_status, @radius_angry_balls),
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
    @balls.each(&:add)
    @finish.add
  end

  def remove
    @balls.each(&:remove)
    @finish.remove
  end
end
