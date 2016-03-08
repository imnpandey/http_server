require "socket"
require './processing'

class MyServer < Processing
  def initialize
    @root_path = "public/"
    @server = TCPServer.new "localhost", 3000
    puts "Connected on port 3000"
    request
  end

  private

  def request
    loop do
      @request = @server.accept
      process_request
      @request.close
    end
  end

  def response(body, status=200)
      header = "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/html\r\n" +
                "Connection: close\r\n"
      unless status == 200
        header = "HTTP/1.1 404 Not Found\r\n" +
                  "Connection: close\r\n"
      end
      @request.print header
      @request.print "\r\n"
      @request.print body
  end
end

MyServer.new
