class Pages
  def parse_request(method, request_url)
    @root_path = "public/"
    file = "index"
    file = get_file_name(request_url) unless request_url == "/"
    if method == "POST"
      write_file
    elsif method == "GET" && file_exists?(file)
      message = serve_file(file)
      response message
    else
       response("Not Found", 404)
    end
  end

  private

  def get_file_name(request_url)
    request_url.split("/")[1]
  end

  def file_exists?(file_name)
    puts "#{@root_path}#{file_name}.html"
    File.exist?("#{@root_path}#{file_name}.html")
  end

  def serve_file(file_name)
    text = open("#{@root_path}#{file_name}.html")
    text.read
  end

  def write_file
    referer = @headers["Referer"].split("/")[-1]
    message = @request.read(@headers["Content-Length"].to_i)
    IO.write("#{@root_path}#{referer}.txt", message)
    response message
  end
end
