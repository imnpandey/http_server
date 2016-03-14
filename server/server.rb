module Server

  def request
    loop do
      @request = @server.accept
      puts @request
      data = parse_request(@request)
      response Mapper.new.process_request(data) #sends to mapper
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

  private

  def parse_request(request)
    data = []
    method, path = request.gets.split(' ')
    data << method << path
    headers = {}
    while line = request.gets.split(' ', 2)
      break if line[0].strip.empty?
      headers[line[0].chop] = line[1].strip
    end
    params = get_params(path) if method.eql? 'GET'
    params = post_params(request, headers) if method.eql? 'POST'
    data << params
    puts "#{method} #{path} #{params}"
    data
  end

  def get_params(path)
    params = []
    if path.include? '?'
      params_string = path.split('?')[1]
      params_string = paramstring.split(' ')[0]
      params  = paramstring.split('&')
    end
    generate_params(params)
  end

  def post_params(request, headers)
    params = request.read(headers['Content-Length'].to_i).split('&')
    generate_params(params)
  end

  def generate_params(params_string)
    params = {}
    params_string.each do |data|
      value = URI.decode_www_form(data)
      params[value[0][0]] = value[0][1]
    end
    params
  end
end
