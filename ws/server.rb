# coding:utf-8
require 'em-websocket'
require 'json'

# Process.daemon(nochdir=true) if ARGV[0] == "-D"
connections = []

ENV_FILE = '/home/dotcloud/environment.json'

port = 12345
if File.exist?(ENV_FILE)
  env = JSON.parse(File.read(ENV_FILE))
  port = env["PORT_WEBSOCKET"].to_i
end

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => port) do |ws|
  ws.onopen {
    ws.send "server: connected"
    connections.push(ws) unless connections.index(ws)
  }
  
  ws.onmessage { |msg|
    puts "received [#{msg}]"
    ws.send msg # to myself
    connections.each {|con|
      # to other people
      unless con == ws
        puts "send [#{msg}]"
        con.send(msg) 
      end
    }
  }
  ws.onclose { puts "#{ws} closed" }
  
  ws.onerror { |er|
    p er
  }
end
