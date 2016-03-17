class Mapper
  MAPPING = {
    '/form_submit' => 'comment#create',
    '/comments' => 'comment#read_comments'
  }.freeze

  MAPPING.values.each {|file| require_relative "../#{file.split("#")[0]}" }

  def process_request(data)
    request, path, params = data
    puts "#{data}"
    method_call = MAPPING[path]
    action = MAPPING[path].nil? ? "static" : "dynamic"
    action, method_call = check_for_data(path) if !specific_id(path).nil?
    action == "static" ? serve_static(data) : serve_dynamic(method_call, data)
  end

  private

  def specific_id(path)
    MAPPING[path.split(/[\/0-9]+$/)[0]]
  end

  def check_for_data(path)
    Array.new.push("dynamic").push(specific_id(path))
  end

  def serve_static(data)
    request_url = data[1]
    @root_path = "public/"
    file = "index"
    file = get_file_name(request_url) unless request_url == "/"
    file_exists?(file) ? serve_file(file) : "Not Found"
  end

  def serve_dynamic(action, data)
    controller_class, method = action.split("#")
    controller_obj = Object.const_get(controller_class.capitalize)
    controller_obj.new(data).send(method)
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
