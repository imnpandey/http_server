module Mapper
  MAPPING = {
    "/form_submit" => "POST",
    "/comments" => "GET"
  }.freeze

  def process_request(data)
    @root_path = "public/"
    request, path, params = data[0], data[1], data[2]
    action = "static"
    MAPPING.each do |key, value|
      action = "dynamic" if path.include? key
    end
    case action
      when "dynamic"
        response serve_other(data)
      else
        response serve_static(data)
     end
  end
end
