require './pages'

module Processing
  include Pages

  def process_request
    method, path = @request.gets.split(" ")
    puts method
    @headers = {}
    while line = @request.gets.split(' ', 2)
      break if line[0].strip.empty?
      @headers[line[0].chop] = line[1].strip
    end
    STDERR.puts path
    parse_request(method, path)
  end
end
