require './mapper'
require './process'
require './pages'

module Server
  include Process
  include Mapper
  include Pages
  def request
    loop do
      @request = @server.accept
      puts @request
      data = parse_request(@request) #to processes
      action = process_request(data) #sends to mapper
      case action
      when "static"
        response serve_static(data)
      else
        response serve_other(data)
     end
      @request.close
    end
  end

  def response(body)
    header = "HTTP/1.1 200 OK\r\n" \
             "Content-Type: text/html\r\n" \
             "Connection: close\r\n"
    unless body == "Not Found"
      header = "HTTP/1.1 404 Not Found\r\n" \
               "Connection: close\r\n"
    end
    @request.print header
    @request.print "\r\n"
    @request.print body
  end
end
