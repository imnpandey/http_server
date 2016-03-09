require 'sqlite3'

module Pages
  def parse_request(method, request_url)
    @root_path = "public/"
    file = "index"
    file = get_file_name(request_url) unless request_url == "/"
    if method == "POST"
      store_DB
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

  def parse_post_data
    message = @request.read(@headers["Content-Length"].to_i).split("&")
    hash = {}
    message.each do |data|
      value = data.split("=")
      hash[value[0]] = value[1].strip
    end
    hash
  end

  def connect_DB
    @database = SQLite3::Database.open( "server.db" )
    @database.execute( "CREATE TABLE IF NOT EXISTS comments (id INTEGER PRIMARY KEY, name TEXT, email TEXT, comments TEXT);" )
  end

  def store_DB
    connect_DB
    data_hash = parse_post_data
    @database.execute("INSERT INTO comments (name, email, comments) VALUES ('#{data_hash['name']}', '#{data_hash['email']}', '#{data_hash['comments']}');")
  end
end
