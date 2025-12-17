require 'ruby2d'
require_relative 'title_screen'
require_relative 'wall'
require_relative 'player'
require_relative 'info'
require_relative 'levels/level_1'
require_relative 'levels/level_2'
require_relative 'levels/level_3'
require_relative 'levels/finish'

set title: "*Insert funny title here*"
set width: 1200, height: 850
set borderless: false
set background: 'black'
set diagnostics: true

@state = :title
@keys_held = {}
current_level = 1

# Title screen
@title_screen = TitleScreen.new
@title_screen.show

# Info screen
@info_screen = InfoScreen.new
@info_screen.hide

# Player
player = Player.new(x: 50, y: 425, size: 84)

# Timer (in seconds)
@timer_start = Time.now
@timer_text = Text.new(
  "Time: 0",
  x: 535, y: 20,
  size: 30,
  color: 'white',
  z: 10,
)

#Death counter
@death_counter = 0
@death_text = Text.new(
  "Deaths: 0",
  x: 50, y:20,
  size: 30,
  color: 'white',
  z: 10,
)

# Load levels
levels = {
  1 => Level1.new,
  2 => Level2.new,
  3 => Level3.new,
}

active_level = levels[current_level]

# Audio
death_audio = Sound.new('audio/coin.mp3')

# Mouse tracking 
on :mouse_move do |event|
  puts "X: #{event.x}, Y: #{event.y}"
  sleep(0.1)
end

# Key handling
on :key_down do |event|
  case @state
  when :title
    if event.key == 'return'
      @state = :game
      @title_screen.hide
      player.add
      active_level.add

      # Initialize level count text
      @level_count&.remove
      @level_count = Text.new(
        "Level #{current_level}",
        x: 550, y: 100,
        size: 35,
        color: 'white',
        z: 1
      )
    elsif event.key == 'i'
      @state = :info
      @title_screen.hide
      @info_screen.show
    

    elsif event.key == 'q'
      close
    end
  
  when :info
    if event.key == 'return'
      # Start game from info screen
      @info_screen.hide
      @state = :game
      player.add
      active_level.add

      @timer_start = Time.now  # restart timer when game starts
    elsif event.key == 'escape'
      # Return to title
      @info_screen.hide
      @title_screen.show
      @state = :title

    elsif event.key == 'q'
      close
    end
  when :game
    @keys_held[event.key] = true

    if event.key == 'escape'
      @state = :title
      @title_screen.show
      player.remove
      active_level.remove
      @keys_held.clear

      # Remove level text
      @level_count&.remove
      @next_level&.remove
      @no_level&.remove

    elsif event.key == 'q'
      close

    elsif event.key == 'n'  # Next level
      active_level.remove
      current_level += 1

      @level_count&.remove
      @next_level&.remove
      @no_level&.remove

      if levels[current_level]
        active_level = levels[current_level]
        active_level.add
        player.shape.x = 50
        player.shape.y = 425

        @level_count = Text.new(
          "Level #{current_level}",
          x: 550, y: 100,
          size: 35,
          color: 'white',
          z: 1
        )
      else
        current_level -= 1 
        @next_level = Text.new(
          "No next level!",
          x: 480, y: 700,
          size: 35,
          color: 'white',
          z: 1
        )
        active_level.add  
      end

    elsif event.key == 'b'  # Previous level
      active_level.remove
      current_level -= 1

      @level_count&.remove
      @next_level&.remove
      @no_level&.remove

      if levels[current_level]
        active_level = levels[current_level]
        active_level.add
        player.shape.x = 50
        player.shape.y = 425

        @level_count = Text.new(
          "Level #{current_level}",
          x: 550, y: 100,
          size: 35,
          color: 'white',
          z: 1
        )
      else
        current_level += 1  
        @no_level = Text.new(
          "No previous level!",
          x: 450, y: 700,
          size: 35,
          color: 'white',
          z: 1
        )
        active_level.add 
      end
    end
  end
end


on :key_up do |event|
  @keys_held.delete(event.key) if @state == :game
end

# Update loop
update do


  if @state == :game

    elapsed_time = Time.now - @timer_start
    @timer_text.text = "Time: #{elapsed_time.round(2)}"
    player.x_speed = 0
    player.y_speed = 0

    player.x_speed = -10 if @keys_held['a'] || @keys_held['left']
    player.x_speed = 10 if @keys_held['d'] || @keys_held['right']
    player.y_speed = -10 if @keys_held['w'] || @keys_held['up']
    player.y_speed = 10 if @keys_held['s'] || @keys_held['down']

    player.move

    # Wall collision
    active_level.walls.each do |wall|
      if wall.colliding?(player.shape, player.size)
        player.shape.x -= player.x_speed
        player.shape.y -= player.y_speed
        player.shape.x = 50   # starting X
        player.shape.y = 425  # starting Y
        death_audio.play
        sleep(0.1)
        @death_counter += 1
        @death_text.text = "Deaths: #{@death_counter}"
      end
    end

    # Window boundaries
    player.shape.x = 0 if player.shape.x < 0
    player.shape.x = Window.width - player.size if player.shape.x + player.size > Window.width
    player.shape.y = 0 if player.shape.y < 0
    player.shape.y = Window.height - player.size if player.shape.y + player.size > Window.height
  end
end

show