#Create Dynamic mappings

module Mapper
  MAPPING = {
    '/form_submit' => 'comment#create',
    '/comments' => 'comment#read_comments'
  }.freeze

  MAPPING.values.each {|file| require_relative "../#{file.split("#")[0]}" }

  def process_request(data)
    @root_path = "public/"
    request, path, params = data[0], data[1], data[2]
    puts path
    action = "dynamic"
    action = "static" if MAPPING[path].nil?
    method_call = MAPPING[path]
    if !MAPPING[path.split(/[\/0-9]+$/)[0]].nil?
      action = "dynamic"
      method_call = MAPPING[path.split(/[\/0-9]+$/)[0]]
    end
      if action == "static"
        serve_static(data)
      elsif action == "dynamic"
         serve_other(method_call, data)
     end
  end

  private

  def serve_static(data)
    request_url = data[1]
    @root_path = "public/"
    file = "index"
    file = get_file_name(request_url) unless request_url == "/"
    if file_exists?(file)
      serve_file(file)
    else
      "Not Found"
    end
  end

  def serve_other(action, data)
    data = Array.new if data.nil?
    controller_class = get_controller_name(action)
    method = action.split("#")[1]
    controller_obj = eval("#{controller_class}.new(data)")
    response = eval("controller_obj.#{method}")
    response
  end

  def get_controller_name(action)
    action.split("#")[0].capitalize
  end

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
end
