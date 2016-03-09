require './db_functions'

module Pages
  include DBFunction
  def parse_request(method, request_url)
    puts request_url
    @root_path = "public/"
    file = "index"
    file = get_file_name(request_url) unless request_url == "/"
    if method == "POST"
      store_DB
    elsif method == "GET" && file == "comments"
      id = request_url.split("/")[-1]
      show_data_DB(id)
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
end
