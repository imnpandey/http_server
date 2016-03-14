require 'sqlite3'
require 'uri'

class Comment
  DB = SQLite3::Database.open( "server.db" )

  def initialize(data)
    @data = data
  end

  def create
    data = @data[2]
    connect_DB
    begin
      DB.execute("INSERT INTO comments (name, email, comments) VALUES ('#{data['name']}', '#{data['email']}', '#{data['comments']}');")
      response = "Data Entered Successfully!"
    rescue SQLite3::Exception => e
      puts "Exception occurred #{e}"
      response = "Exception Occured."
    end
  end

  def read_comments
    data = @data
    id = data[1].split("/")[-1]
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
    id, name, email, comment = row
    "<tr><td><a href='/comments/#{id}'>#{id}</a></td><td>#{name}</td> <td>#{email}</td><td>#{comment}</td></tr>"
  end
end
