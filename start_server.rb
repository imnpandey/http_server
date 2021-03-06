require "socket"
require "optparse"
require "./lib/server/server"
require './lib/server/mapper'

class MyServer
  include Server

  def initialize
    port = 3000
    @server = TCPServer.new "localhost", port
    puts "Connected on port #{port}"
    request
  end
end

MyServer.new
