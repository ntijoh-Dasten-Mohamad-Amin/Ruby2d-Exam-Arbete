# info.rb
require 'ruby2d'

class InfoScreen
  def initialize
    # Keep track of all shapes/texts
    @elements = []
  end

  def show
    # Yellow background
    bg = Rectangle.new(
      x: 0, y: 0, z: 4,
      width: Window.width,
      height: Window.height,
      color: 'green'
    )
    @elements << bg

    # Title text
    title = Text.new(
      'Info Screen',
      x: 450, y: 225, z: 4,
      size: 48,
      color: 'black'
    )
    @elements << title

    # Instructions
    instructions_1 = Text.new(
      'Use WASD or Arrow keys to move.',
      x: 375, y: 350, z: 4,
      size: 28,
      color: 'black'
    )
    @elements << instructions_1

      instructions_2 = Text.new(
      'Avoid the red walls and reach Biggie Cheese to progress!',
      x: 250, y: 425, z: 4,
      size: 28,
      color: 'black'
    )
    @elements << instructions_2

      instructions_3 = Text.new(
      'Press N to go to the next level & Press B to go back a level.',
      x: 240, y: 500, z: 4,
      size: 28,
      color: 'black'
    )
    @elements << instructions_3
    
  end

  def hide
    # Remove all elements from the window
    @elements.each(&:remove)
    @elements.clear
  end
end
