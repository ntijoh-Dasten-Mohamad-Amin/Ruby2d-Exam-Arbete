require 'ruby2d'

class TitleScreen
  def initialize
    @elements = []


    @elements << Image.new(
      'img/background.jpg',
      x: 0, y: 0, z: 4,
      width: Window.width,
      height: Window.height
    )
    @elements << Text.new(
      "*Insert funny title here*",
      x: 300,
      y: 250,
      size: 60,
      color: 'white',
      z: 10
    )

    @elements << Text.new(
      "Press ENTER to start",
      x: 430,
      y: 380,
      size: 30,
      color: 'white',
      z: 10
    )

    @elements << Text.new(
      "Press I for info",
      x: 480,
      y: 430,
      size: 24,
      color: 'white',
      z: 10
    )

    @elements << Text.new(
      "Press Q to quit",
      x: 480,
      y: 470,
      size: 24,
      color: 'white',
      z: 10
    )

    # @elements << Rectangle.new(
    #   x: 0, y: 0,
    #   width: Window.width,
    #   height: Window.height,
    #   color: 'orange',
    #   z: 5
    # )
  end

  def show
    @elements.each(&:add)
  end

  def hide
    @elements.each(&:remove)
  end
end
