require 'ruby2d'

class TitleScreen
  def initialize
    @elements = []

    @elements << Text.new(
      "*Insert funny title here*",
      x: 350,
      y: 250,
      size: 60,
      color: 'white',
      z: 10
    )

    @elements << Text.new(
      "Press ENTER to start",
      x: 420,
      y: 380,
      size: 30,
      color: 'gray',
      z: 10
    )

    @elements << Text.new(
      "Press I for info",
      x: 470,
      y: 430,
      size: 24,
      color: 'gray',
      z: 10
    )

    @elements << Text.new(
      "Press Q to quit",
      x: 470,
      y: 470,
      size: 24,
      color: 'gray',
      z: 10
    )
  end

  def show
    @elements.each(&:add)
  end

  def hide
    @elements.each(&:remove)
  end
end
