require './db_functions'

module Pages
  include DBFunction

  def serve_static(data)
    request_url = data[1]
    @root_path = "public/"
    file = "index"
    file = get_file_name(request_url) unless request_url == "/"
    if file_exists?(file)
      serve_file(file)
    else
      "Not Found"
    end
  end

  def serve_other(data)
    "test post"
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
