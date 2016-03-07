require "socket"

class MyServer
  def initialize
    port = rand(999) + 3000
    @server = TCPServer.new "localhost", port
    puts "Connected on port #{port}"
    req
  end

  def req
    loop do
      @client = @server.accept
      request = @client.gets
      STDERR.puts request
      res
      @client.close
    end
  end

  def res
      response = "OK\n"
      @client.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: #{response.bytesize}\r\n" +
                   "Connection: close\r\n"
      @client.print "\r\n"
      @client.print response
  end
end

MyServer.new
