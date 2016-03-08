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
      request_url = parse_url(request)
      parse_request(request_url)
      @client.close
    end
  end

  def res(response, status=200)
      message = "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: #{response.bytesize}\r\n" +
                "Connection: close\r\n"
      unless status == 200
        message = "HTTP/1.1 404 Not Found\r\n" +
                  "Connection: close\r\n"
      end
      @client.print message
      @client.print "\r\n"
      @client.print response
  end

  def parse_url(request)
    request_uri  = request.split(" ")[1]
  end

  def parse_request(request_url)
    case request_url
    when "/home"
      res("You are on home")
    when "/about"
      res("You are on about")
    when "/"
      res("welcome, root")
    else
      res("Not Found", 404)
    end

  end
end

MyServer.new
