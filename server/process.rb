module Process

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
    paramarray = []
    if path.include? '?'
      paramstring = path.split('?')[1]
      paramstring = paramstring.split(' ')[0]
      paramarray  = paramstring.split('&')
    end
    generate_params(paramarray)
  end

  def post_params(request, headers)
    paramarray = request.read(headers['Content-Length'].to_i).split('&')
    generate_params(paramarray)
  end

  def generate_params(array)
    params = {}
    array.each do |data|
      value = data.split('=')
      params[value[0]] = value[1]
    end
    params
  end
end
