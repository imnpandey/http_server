module Pages
  class ServePages
    def parse_request(request_url)
      case request_url
      when "/home"
        message = serve_file(request_url)
        response message
      when "/about"
        message = serve_file(request_url)
        response message
      when "/comments"
        message = serve_file(request_url)
        response message
      when "/form_submit"
        message = write_file
        response message
      when "/"
        message = serve_file("/index")
        response message
      else
        response("Not Found", 404)
      end
    end

    def serve_file(request_url)
      file_name = request_url.split("/")[1]
      text = open(@root_path + file_name + ".html")
      text.read
    end

    def write_file
      referer = @headers["Referer"].split("/")[-1]
      content = @client.read(@headers["Content-Length"].to_i)
      IO.write(@root_path + referer + ".txt", content)
    end
  end
end
