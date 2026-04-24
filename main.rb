require 'ruby2d'
require_relative 'title_screen'
require_relative 'wall'
require_relative 'player'
require_relative 'info'
require_relative 'moving_object'
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

# -------------------------
# Players (LOCAL MULTIPLAYER)
# -------------------------
players = []
players << Player.new(x: 50, y: 380, size: 84, color: 'yellow')
players << Player.new(x: 150, y: 380, size: 84, color: 'blue')

players.each(&:remove)

# -------------------------
# UI
# -------------------------
@title_screen = TitleScreen.new
@title_screen.show

@info_screen = InfoScreen.new
@info_screen.hide

@timer_start = Time.now
@timer_text = Text.new("Time: 0", x: 535, y: 20, size: 30, color: 'white', z: 10)
@timer_text.remove

@death_counter = 0
@death_text = Text.new("Deaths: 0", x: 900, y: 40, size: 30, color: 'white', z: 10)
@death_text.remove

@last_mouse_log = Time.now

# -------------------------
# Levels
# -------------------------
levels = {
  1 => Level1,
  2 => Level2,
  3 => Level3,
  4 => Level4,
}

def load_level(levels, number, players)
  level = levels[number].new
  level.add

  # Reset ALL players
  players.each_with_index do |player, i|
    player.shape.x = 50 + (i * 100)
    player.shape.y = 380
  end

  level
end

active_level = load_level(levels, current_level, players)
active_level.remove

death_audio = Sound.new('audio/bruh.mp3')
win_audio = Sound.new('audio/coin.mp3')

# -------------------------
# Input
# -------------------------
on :key_down do |event|
  case @state
  when :title
    case event.key
    when 'return'
      @state = :game
      @title_screen.hide
      players.each(&:add)
      active_level.add
      @timer_text.add
      @death_text.add
      @timer_start = Time.now

      @level_count&.remove
      @level_count = Text.new("Level #{current_level}", x: 50, y: 20, size: 35, color: 'white')

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
      players.each(&:add)
      active_level.add
      @timer_text.add
      @death_text.add
      @timer_start = Time.now

    when 'escape'
      @info_screen.hide
      @title_screen.show
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
      players.each(&:remove)
      active_level.remove
      @timer_text.remove
      @death_text.remove
      @keys_held.clear

    when 'q'
      close

    when 'n'
      active_level.remove
      current_level += 1

      if levels[current_level]
        active_level = load_level(levels, current_level, players)
      else
        current_level -= 1
        active_level.add
      end

    when 'b'
      active_level.remove
      current_level -= 1

      if levels[current_level]
        active_level = load_level(levels, current_level, players)
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
# Game Loop
# -------------------------
update do
  next unless @state == :game

  elapsed = Time.now - @timer_start
  @timer_text.text = "Time: #{elapsed.round(2)}"

  # -------------------------
  # Player 1 (WASD)
  # -------------------------
  p1 = players[0]
  p1.x_speed = 0
  p1.y_speed = 0
  p1.x_speed = -10 if @keys_held['a']
  p1.x_speed = 10  if @keys_held['d']
  p1.y_speed = -10 if @keys_held['w']
  p1.y_speed = 10  if @keys_held['s']

  # -------------------------
  # Player 2 (Arrow Keys)
  # -------------------------
  p2 = players[1]
  p2.x_speed = 0
  p2.y_speed = 0
  p2.x_speed = -10 if @keys_held['left']
  p2.x_speed = 10  if @keys_held['right']
  p2.y_speed = -10 if @keys_held['up']
  p2.y_speed = 10  if @keys_held['down']

  players.each(&:move)

  # -------------------------
  # Collision
  # -------------------------
  players.each do |player|
    active_level.walls.each do |wall|
      if wall.colliding?(player.shape, player.size)
        player.shape.x = 50
        player.shape.y = 380
        death_audio.play
        @death_counter += 1
        @death_text.text = "Deaths: #{@death_counter}"
        break
      end
    end
  end

  # -------------------------
  # Finish check
  # -------------------------
  finish = active_level.finish

  players.each do |player|
    if finish &&
      player.shape.x < finish.x + finish.width &&
      player.shape.x + player.size > finish.x &&
      player.shape.y < finish.y + finish.height &&
      player.shape.y + player.size > finish.y

      win_audio.play
      active_level.remove
      current_level += 1

      if levels[current_level]
        active_level = load_level(levels, current_level, players)
      else
        close
      end
    end
  end

  # -------------------------
  # Window bounds
  # -------------------------
  players.each do |player|
    player.shape.x = player.shape.x.clamp(0, Window.width - player.size)
    player.shape.y = player.shape.y.clamp(0, Window.height - player.size)
  end
end

show