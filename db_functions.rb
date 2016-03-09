require 'sqlite3'

module DBFunction
  DB = SQLite3::Database.open( "server.db" )

  def store_DB
    connect_DB
    data_hash = parse_post_data
    DB.execute("INSERT INTO comments (name, email, comments) VALUES ('#{data_hash['name']}', '#{data_hash['email']}', '#{data_hash['comments']}');")
    response("Data Entered Successfully!")
    #close_DB
  end

  def show_data_DB(id)
    query = ""
    query = "WHERE id = #{id}"if !!(id =~ /\d+/)
    rows = DB.execute( "select * from comments #{query}" )
    if rows.length > 0
      data = "<table>#{parse_response_data(rows)}</table>"
      response(data)
    else
      response("Not Found", 404)
    end
    #close_DB
  end

  private

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
    DB.execute( "CREATE TABLE IF NOT EXISTS comments (id INTEGER PRIMARY KEY, name TEXT, email TEXT, comments TEXT);" )
  end

  def close_DB
    DB.close if DB
  end

  def parse_response_data(rows)
    rows.map do |row|
      make_response(row)
    end.join
  end

  def make_response(row)
    "<tr><td><a href='/comments/#{row[0]}'>#{row[0]}</a></td><td>#{row[1]}</td> <td>#{row[2]}</td><td>#{row[3]}</td></tr>"
  end
end
