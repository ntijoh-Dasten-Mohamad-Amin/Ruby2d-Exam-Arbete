class Balls

    attr_reader :balls

    def initialize(x, y_speed, y, x_speed, game_status, radius_angry_balls)
        @y_speed = y_speed
        @x_speed = x_speed
        @game_status = game_status

        @balls = Circle.new( 
        x: x,
        y: y,
        radius: radius_angry_balls,
        color: 'red',
        z: 100
        )

    end

    def move 
        ball_movement
    end
end