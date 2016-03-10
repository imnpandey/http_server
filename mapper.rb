module Mapper
  MAPPING = {
    "/comments" => "POST"
  }.freeze

  def process_request(data)
    @root_path = "public/"
    request = data[0]
    path = data[1]
    params = data[2]
    return "static" if MAPPING[path].nil?
    "dynamic"
  end
end
