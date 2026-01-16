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
      x: 450, y: 250, z: 4,
      size: 48,
      color: 'black'
    )
    @elements << title

    # Instructions
    instructions_1 = Text.new(
      'Use WASD or Arrow keys to move.',
      x: 350, y: 375, z: 4,
      size: 28,
      color: 'black'
    )
    @elements << instructions_1

      instructions_2 = Text.new(
      'Avoid the red walls and reach Biggie Cheese!',
      x: 300, y: 450, z: 4,
      size: 28,
      color: 'black'
    )
    @elements << instructions_2
  end

  def hide
    # Remove all elements from the window
    @elements.each(&:remove)
    @elements.clear
  end
end
