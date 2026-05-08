require 'socket'
require 'json'
require 'thread'

class Network
  attr_reader :state, :player_id

  def initialize(host, port, player_id)
    @player_id = player_id
    @state = { "players" => {}, "level" => 1, "deaths" => 0 }
    @mutex = Mutex.new
    @socket = TCPSocket.new(host, port)

    Thread.new do
      while (line = @socket.gets rescue nil)
        parsed = JSON.parse(line.chomp) rescue nil
        @mutex.synchronize { @state = parsed } if parsed
      end
    end
  end

def send_input(x0, y0, x1, y1)
  @socket.puts({ players: { "0" => { x: x0, y: y0 }, "1" => { x: x1, y: y1 } } }.to_json)
rescue
end

  # def send_level(x)
  #   @socket.puts({id: @player_id, command: "levelChange", data: {id: x}}.to_json)
  # rescue
  # end

  def state
    @mutex.synchronize { @state.dup }
  end
end