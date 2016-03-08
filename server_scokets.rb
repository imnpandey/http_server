require "socket"
require 'net/http'

module Pages
  class ServePages
    def parse_url(request)
      request_uri  = request.split(" ")[1]
    end

    def parse_request(request_url)
      case request_url
      when "/home"
        message = serve_file(request_url)
        response message
      when "/about"
        message = serve_file(request_url)
        response message
      when "/comments"
        message = serve_file(request_url)
        response message
      when "/"
        message = serve_file("/index")
        response message
      else
        response("Not Found", 404)
      end
    end

    def serve_file(request_url)
      file_name = request_url.split("/")[1]
      text = open(@root_path + file_name + ".html")
      text.read
    end
  end
end

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
      request = @client.gets
      STDERR.puts request
      request_url = parse_url(request)
      parse_request(request_url)
      @client.close
    end
  end

  def response(body, status=200)
      header = "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: #{body.bytesize}\r\n" +
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
