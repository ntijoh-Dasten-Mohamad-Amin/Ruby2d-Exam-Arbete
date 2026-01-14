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
      color: 'brown'
    )
    @elements << bg

    # Title text
    title = Text.new(
      'Info Screen',
      x: 50, y: 50, z: 4,
      size: 30,
      color: 'black'
    )
    @elements << title

    # Instructions
    instructions = Text.new(
      'PLACEHOLDER INFO TEXT BLAST',
      x: 50, y: 100, z: 4,
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
