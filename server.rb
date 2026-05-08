require 'socket'
require 'json'
require 'thread'

PORT = 2345
clients = []
game_state = { players: {}, level: 1, deaths: 0, timer: 0.0 }
mutex = Mutex.new

server = TCPServer.new('0.0.0.0', PORT)
puts "Waiting for 2 players on port #{PORT}..."
i = 0
# 2.times do |i|
while true do
  client = server.accept
  client.puts({ assigned_id: i }.to_json)
  mutex.synchronize { clients << client }
  puts "Player #{i + 1} connected!"

  Thread.new(client, i) do |c, player_id|
    while (line = c.gets rescue nil)
      data = JSON.parse(line.chomp) rescue next
      p data

      mutex.synchronize do
        game_state[:players][player_id.to_s] = data

        payload = game_state.to_json
        clients.each { |cl| cl.puts(payload) rescue nil }
      end
    end

    mutex.synchronize { clients.delete(c) }
    puts "Player #{player_id + 1} disconnected."
  end
  i += 1
end

puts "Both players connected — game running!"
sleep

# {commando: pos, data: {id: 0, pos: 15}}
# {commando: level, data: {id: 2}}
