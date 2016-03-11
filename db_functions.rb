require 'sqlite3'

module DBFunction
  DB = SQLite3::Database.open( "server.db" )

  def store_DB(all_data)
    data = all_data[2]
    connect_DB
    begin
      DB.execute("INSERT INTO comments (name, email, comments) VALUES ('#{data['name']}', '#{data['email']}', '#{data['comments']}');")
      response = "Data Entered Successfully!"
    rescue SQLite3::Exception => e
      response = "Exception Occured."
      puts "Exception occurred #{e}"
    end
  end

  def show_data_DB(id)
    query = ""
    query = "WHERE id = #{id}"if !!(id =~ /\d+/)
    rows = DB.execute( "select * from comments #{query}" )
    if rows.length > 0
      data = "<table>#{parse_response_data(rows)}</table>"
      response = data
    else
      response = "Not Found"
    end
  end

  private

  def connect_DB
    begin
      DB.execute( "CREATE TABLE IF NOT EXISTS comments (id INTEGER PRIMARY KEY, name TEXT, email TEXT, comments TEXT);" )
    rescue SQLite3::Exception => e
      puts "Exception occurred #{e}"
    end
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
