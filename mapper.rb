module Mapper
  MAPPING = {
    "/form_submit" => "POST",
    "/comments" => "GET"
  }.freeze

  def process_request(data)
    @root_path = "public/"
    request, path, params = data[0], data[1], data[2]
    MAPPING.each do |key, value|
      return "dynamic" if path.include? key
    end
    "static"
  end
end
