require "socket"
require "./server/server"
require './server/mapper'
require './server/process'
require './pages'
require './db_functions'

class MyServer
  include Server
  include Process
  include Mapper
  include Pages
  include DBFunction

  def initialize
    port = ARGV[0] || 3000
    @server = TCPServer.new "localhost", port
    puts "Connected on port #{port}"
    request
  end
end

MyServer.new
git
