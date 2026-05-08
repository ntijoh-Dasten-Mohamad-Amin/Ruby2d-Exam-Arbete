require 'socket'
require 'json'
require 'ruby2d'
require_relative 'network'
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

# ── Network setup ──────────────────────────────────────────────────────────────
# Usage: ruby main.rb <server_ip> <player_id>
#   Player 0 = yellow, WASD controls
#   Player 1 = blue,   arrow key controls
# Examples:
#   ruby main.rb 127.0.0.1 0   (host machine, player 1)
#   ruby main.rb 192.168.1.42 1 (LAN machine, player 2)
HOST      = ARGV[0] || "127.0.0.1"
PLAYER_ID = (ARGV[1] || "0").to_i
net = Network.new(HOST, 2345, PLAYER_ID)

set title: "*Insert funny title here*"
set width: 1200, height: 850
set background: 'black'
set diagnostics: true

@state = :title
@keys_held = {}
current_level = 1

players = []
players << Player.new(x: 50,  y: 380, size: 84, color: 'yellow')
players << Player.new(x: 150, y: 380, size: 84, color: 'blue')
players.each(&:remove)

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

levels = {
  1 => Level1,
  2 => Level2,
  3 => Level3,
  # 4 => Level4,
}

def load_level(levels, number, players)
  level = levels[number].new
  level.add
  players.each_with_index do |player, i|
    player.shape.x = 50 + (i * 100)
    player.shape.y = 380
  end
  level
end

active_level = load_level(levels, current_level, players)
active_level.remove

death_audio = Sound.new('audio/bruh.mp3')
win_audio   = Sound.new('audio/coin.mp3')

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

update do
  next unless @state == :game

  elapsed = Time.now - @timer_start
  @timer_text.text = "Time: #{elapsed.round(2)}"

  s = net.state

  local = players[PLAYER_ID]
  local.x_speed = 0
  local.y_speed = 0

  if PLAYER_ID == 0
    local.x_speed = -10 if @keys_held['a']
    local.x_speed =  10 if @keys_held['d']
    local.y_speed = -10 if @keys_held['w']
    local.y_speed =  10 if @keys_held['s']
  else
    local.x_speed = -10 if @keys_held['left']
    local.x_speed =  10 if @keys_held['right']
    local.y_speed = -10 if @keys_held['up']
    local.y_speed =  10 if @keys_held['down']
  end

  local.move
  # net.send_level(10)
  net.send_input(local.shape.x, local.shape.y)

  s["players"].each do |id, data|
    next if id.to_i == PLAYER_ID
    players[id.to_i].shape.x = data["x"]
    players[id.to_i].shape.y = data["y"]
  end

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

  finish = active_level.finish
  all_players_in_finish = players.all? do |player|
    finish &&
      player.shape.x < finish.x + finish.width &&
      player.shape.x + player.size > finish.x &&
      player.shape.y < finish.y + finish.height &&
      player.shape.y + player.size > finish.y
  end

  if all_players_in_finish
    win_audio.play
    active_level.remove
    current_level += 1

    if levels[current_level]
      active_level = load_level(levels, current_level, players)
      @level_count.text = "Level #{current_level}"
    else
      close
    end
  end

  players.each do |player|
    player.shape.x = player.shape.x.clamp(0, Window.width  - player.size)
    player.shape.y = player.shape.y.clamp(0, Window.height - player.size)
  end
end

show