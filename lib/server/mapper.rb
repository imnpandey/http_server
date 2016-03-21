require_relative '../../routes'

class Mapper
  include Routes

  MAPPING.values.each do |file|
    path = "../../app/#{file.split("#")[0]}"
    puts "#{path}.rb"
    puts File.exist?("#{path}.rb")
    require_relative path if File.exist?("#{path}.rb")
  end

  CONTENT_TYPE = {
    'css' => 'text/css',
    'js' => 'application/javascript',
    'jpeg' => 'image/jpeg',
    'jpg' => 'image/jpeg',
    'png' => 'image/png',
    'txt' => 'text/plain',
    'gif' => 'image/gif',
    'html' => 'text/html',
    'htm' => 'text/html',
    'xml' => 'text/xml'
  }.freeze

  def process_request(data)
    request, path, params = data
    puts "#{data}"
    content = []
    method_call = MAPPING[path]
    action = MAPPING[path].nil? ? "static" : "dynamic"
    action, method_call = check_for_data(path) if !specific_id(path).nil?
    content << (action == "static" ? serve_static(data)
                                  : serve_dynamic(method_call, data))
    content << return_file_type(path)
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
    @root_path = "app/public/"
    file = "index"
    file = get_file_name(request_url) unless request_url == "/"
    file_exists?(file) ? serve_file(file) : serve_helper(request_url)
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
    File.exist?("#{@root_path}#{file_name}.html")
  end

  def serve_file(file_name)
    text = open("#{@root_path}#{file_name}.html")
    text.read
  end

  def serve_helper(file_name)
    path = "#{@root_path}#{file_name[1..-1]}"
    File.exist?(path) ? open(path).read : "Not Found"
  end

  def file_type(file_name)
    file_type = file_name.split(".")[-1]
    CONTENT_TYPE[file_type]
  end
end
