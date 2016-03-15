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
      DB.execute("INSERT INTO comments (name, email, comments)" \
                 "VALUES ('#{data['name']}', '#{data['email']}'," \
                 "'#{data['comments']}');")
      "Data Entered Successfully!"
    rescue SQLite3::Exception => e
      puts "Exception occurred #{e}"
    end
  end

  def read_comments
    rows = DB.execute( "select * from comments #{check_query_id}" )
    rows.length > 0 ? "<table>#{parse_response_data(rows)}</table>"
                    : "Not Found"
  end

  private

  def connect_DB
    begin
      DB.execute( "CREATE TABLE IF NOT EXISTS comments " \
        "(id INTEGER PRIMARY KEY, name TEXT, email TEXT, comments TEXT);" )
    rescue SQLite3::Exception => e
      puts "Exception occurred #{e}"
    end
  end

  def close_DB
    DB.close if DB
  end

  def parse_response_data(rows)
    rows.map{ |row| make_response(row) }.join
  end

  def make_response(row)
    id, name, email, comment = row
    "<tr><td><a href='/comments/#{id}'>#{id}</a></td><td>#{name}</td>" \
    "<td>#{email}</td><td>#{comment}</td></tr>"
  end

  def check_query_id
    id = @data[1].split("/")[-1]
    !!(id =~ /\d+/) ? "WHERE id = #{id}" : ""
  end
end
