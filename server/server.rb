module Server

  def request
    loop do
      @request = @server.accept
      puts @request
      data = parse_request(@request) #to processes
      process_request(data) #sends to mapper
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
