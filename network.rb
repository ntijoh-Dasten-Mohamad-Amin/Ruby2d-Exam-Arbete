require 'socket'
require 'json'
require 'thread'

class Network
  attr_reader :state, :player_id

  def initialize(host, port)
    @player_id = nil
    @state = { "players" => {}, "level" => 1, "deaths" => 0 }
    @mutex = Mutex.new
    @socket = TCPSocket.new(host, port)

    # First message from server is our assigned ID
    first = JSON.parse(@socket.gets.chomp)
    @player_id = first["assigned_id"]
    puts "Assigned player ID: #{@player_id}"

    Thread.new do
      while (line = @socket.gets rescue nil)
        parsed = JSON.parse(line.chomp) rescue nil
        @mutex.synchronize { @state = parsed } if parsed
      end
    end
  end

  def send_input(x, y)
    @socket.puts({ id: @player_id, x: x, y: y }.to_json)
  rescue
  end

  def state
    @mutex.synchronize { @state.dup }
  end
end