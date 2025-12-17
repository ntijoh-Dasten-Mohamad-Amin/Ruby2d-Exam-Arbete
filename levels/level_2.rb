# levels/level1.rb
require_relative '../wall'

def load_level2
  {
    walls: [
      Wall.new(x: 300, y: 400, width: 300, height: 100),
      Wall.new(x: 300, y: 100, width: 100, height: 300),
      Wall.new(x: 700, y: 400, width: 100, height: 500),
      Wall.new(x: 100, y: 100, width: 300, height: 100)
    ],
    finish: Image.new('img/biggie.jpeg', x: 1115, y: 425, width: 85, height: 85)
  }
end
