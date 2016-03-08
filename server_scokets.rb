require "socket"
require './pages'

class MyServer < Pages::ServePages
  def initialize
    @root_path = "public/"
    @server = TCPServer.new "localhost", 3000
    puts "Connected on port 3000"
    request
  end

  private

  def request
    loop do
      @client = @server.accept
      path = @client.gets.split(" ")[1]
      @headers = {}
      while line = @client.gets.split(' ', 2)
        break if line[0].strip.empty?
        @headers[line[0].chop] = line[1].strip
      end
      STDERR.puts path
      parse_request(path)
      @client.close
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
      @client.print header
      @client.print "\r\n"
      @client.print body
  end
end

MyServer.new
