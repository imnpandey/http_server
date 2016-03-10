require './pages'

module Processing
  include Pages

  def request_data(data)
    message = serve_file(file)
      response message
  end

end
