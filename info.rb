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
      x: 0, y: 0,
      width: Window.width,
      height: Window.height,
      color: 'yellow'
    )
    @elements << bg

    # Title text
    title = Text.new(
      'Info Screen',
      x: 50,
      y: 50,
      size: 30,
      color: 'black'
    )
    @elements << title

    # Instructions
    instructions = Text.new(
      'Press RETURN to start or ESC to go back',
      x: 50,
      y: 100,
      size: 20,
      color: 'black'
    )
    @elements << instructions
  end

  def hide
    # Remove all elements from the window
    @elements.each(&:remove)
    @elements.clear
  end
end
