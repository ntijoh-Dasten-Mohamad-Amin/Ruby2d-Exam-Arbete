require 'ruby2d'
require_relative 'title_screen'
require_relative 'wall'
require_relative 'player'
require_relative 'info'
require_relative 'levels/level_1'
require_relative 'levels/level_2'
require_relative 'levels/level_3'
require_relative 'levels/level_4'
require_relative 'levels/finish'

set title: "*Insert funny title here*"
set width: 1200, height: 850
set background: 'black'
set diagnostics: true

@state = :title
@keys_held = {}
current_level = 1

@title_screen = TitleScreen.new
@title_screen.show

@info_screen = InfoScreen.new
@info_screen.hide

player = Player.new(x: 0, y: 0, size: 84)
player.remove

@timer_start = Time.now
@timer_text = Text.new("Time: 0", x: 535, y: 20, size: 30, color: 'white', z: 10)
@timer_text.remove

@death_counter = 0
@death_text = Text.new("Deaths: 0", x: 900, y: 40, size: 30, color: 'white', z: 10)
@death_text.remove

@last_mouse_log = Time.now

on :mouse_move do |event|
  # throttle logging to once every 0.1s
  if Time.now - @last_mouse_log > 0.1
    puts "Mouse X: #{event.x}, Mouse Y: #{event.y}"
    @last_mouse_log = Time.now
  end
end

levels = {
  1 => Level1,
  2 => Level2,
  3 => Level3,
  4 => Level4,
}

def load_level(levels, number, player)
  level = levels[number].new
  level.add

  player.shape.x = 50
  player.shape.y = 380

  level
end

active_level = load_level(levels, current_level, player)
active_level.remove # hide until game starts

death_audio = Sound.new('audio/bruh.mp3')
win_audio = Sound.new('audio/coin.mp3')

on :key_down do |event|
  case @state
  when :title
    case event.key
    when 'return'
      @state = :game
      @title_screen.hide
      player.add
      active_level.add
      @timer_text.add
      @death_text.add

      @timer_start = Time.now

      @level_count&.remove
      @level_count = Text.new(
        "Level #{current_level}",
        x: 50, y: 20, z: 10,
        size: 35,
        color: 'white'
      )

    when 'i'
      @state = :info
      @title_screen.hide
      @info_screen.show

    when 'q'
      close
    end

  when :info
    case event.key
    when 'return'
      @info_screen.hide
      @state = :game
      player.add
      active_level.add
      @timer_text.add
      @death_text.add
      @timer_start = Time.now
      @level_count&.remove
      @level_count = Text.new(
        "Level #{current_level}",
        x: 50, y: 20, z: 10,
        size: 35,
        color: 'white'
      )


    when 'escape'
      @info_screen.hide
      @title_screen.show
      @timer_text.remove
      @death_text.remove
      @state = :title

    when 'q'
      close
    end

  when :game
    @keys_held[event.key] = true

    case event.key
    when 'escape'
      @state = :title
      @title_screen.show
      player.remove
      active_level.remove
      @timer_text.remove
      @death_text.remove
      @keys_held.clear

      @level_count&.remove

    when 'q'
      close

    when 'i'
      @state = :info
      @title_screen.hide
      @info_screen.show
      player.remove
      active_level.remove
      @timer_text.remove
      @death_text.remove
      @keys_held.clear

      @level_count&.remove

    when 'n' # next level
      active_level.remove
      current_level += 1

      if levels[current_level]
        active_level = load_level(levels, current_level, player)

        @level_count&.remove
        @level_count = Text.new(
          "Level #{current_level}",
          x: 50, y: 20, z: 10,
          size: 35,
          color: 'white'
        )
      else
        current_level -= 1
        active_level.add
      end

    when 'b' # previous level
      active_level.remove
      current_level -= 1

      if levels[current_level]
        active_level = load_level(levels, current_level, player)
        @level_count&.remove
        @level_count = Text.new(
          "Level #{current_level}",
          x: 50, y: 20, z: 10,
          size: 35,
          color: 'white'
        )
      else
        current_level += 1
        active_level.add
      end
    end
  end
end

on :key_up do |event|
  @keys_held.delete(event.key)
end

# -------------------------
# Update loop
# -------------------------
update do
  next unless @state == :game

  elapsed = Time.now - @timer_start
  @timer_text.text = "Time: #{elapsed.round(2)}"

  player.x_speed = 0
  player.y_speed = 0

  player.x_speed = -10 if @keys_held['a'] || @keys_held['left']
  player.x_speed = 10  if @keys_held['d'] || @keys_held['right']
  player.y_speed = -10 if @keys_held['w'] || @keys_held['uwdp']
  player.y_speed = 10  if @keys_held['s'] || @keys_held['down']

  player.move

  # Wall collision
  active_level.walls.each do |wall|
    if wall.colliding?(player.shape, player.size)
      player.shape.x = 50
      player.shape.y = 380
      death_audio.play
      sleep(0.1)
      @death_counter += 1
      @death_text.text = "Deaths: #{@death_counter}"
      break
    end
  end

  finish = active_level.finish

if finish &&
  player.shape.x < finish.x + finish.width &&
  player.shape.x + player.size > finish.x &&
  player.shape.y < finish.y + finish.height &&
  player.shape.y + player.size > finish.y
  win_audio.play


  # Go to next level
  active_level.remove
  current_level += 1

  if levels[current_level]
    active_level = load_level(levels, current_level, player)

    @level_count&.remove
    @level_count = Text.new(
      "Level #{current_level}",
      x: 50, y: 20,
      size: 35,
      color: 'white'
    )
  else
    puts "🎉 You beat the game!"
    close
  end
end


  # Window bounds
  player.shape.x = player.shape.x.clamp(0, Window.width - player.size)
  player.shape.y = player.shape.y.clamp(0, Window.height - player.size)
end

show
