require 'socket'
require 'json'
require 'thread'

PORT = 2345
clients = []
game_state = { "players" => {}, "level" => 1, "deaths" => 0 }
mutex = Mutex.new

server = TCPServer.new(PORT)
puts "Waiting for 2 players on port #{PORT}..."

2.times do |i|
  client = server.accept
  mutex.synchronize { clients << client }

  # First message to client: their assigned player ID
  client.puts({ assigned_id: i }.to_json)
  puts "Player #{i + 1} connected! (ID #{i})"

  Thread.new(client, i) do |c, player_id|
    while (line = c.gets rescue nil)
      data = JSON.parse(line.chomp) rescue next

      mutex.synchronize do
        # Update position if present
        if data["x"] && data["y"]
          game_state["players"][data["id"].to_s] = { "x" => data["x"], "y" => data["y"] }
        end

        # Update level if present
        if data["level"]
          game_state["level"] = data["level"]
        end

        # Broadcast full state to all clients
        clients.each { |cl| cl.puts(game_state.to_json) rescue nil }
      end
    end
  end
end
  
puts "Both players connected — game running!"
sleep