require './processing'

module Server
  include Processing

  def request
    loop do
      @request = @server.accept
      puts @request
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

  private

  def process_request
    method, path = @request.gets.split(" ")
    puts path
    headers = {}
    while line = @request.gets.split(' ', 2)
      break if line[0].strip.empty?
      headers[line[0].chop] = line[1].strip
    end
    params = get_params(path) if method.eql? "GET"
    params = post_params(headers) if method.eql? "POST"
    puts "#{method} #{path} #{params}"
  end

  def get_params(path)
    paramarray = []
    if path.include? "?"
      paramstring = path.split('?')[1]
      paramstring = paramstring.split(' ')[0]
      paramarray  = paramstring.split('&')
    end
    generate_params(paramarray)
  end

  def post_params(headers)
    paramarray = @request.read(headers["Content-Length"].to_i).split("&")
    generate_params(paramarray)
  end

  def generate_params(array)
    params = {}
    array.each do |data|
      value = data.split("=")
      params[value[0]] = value[1]
    end
    params
  end
end
