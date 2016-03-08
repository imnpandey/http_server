require "socket"
require "./server"

class MyServer
  include Server

  def initialize
    port = ARGV[0] || 3000
    @server = TCPServer.new "localhost", port
    puts "Connected on port #{port}"
    request
  end
end

MyServer.new
