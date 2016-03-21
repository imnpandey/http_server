module Routes
  MAPPING = {
    '/form_submit' => 'comment#create',
    '/comments' => 'comment#read_comments'
  }.freeze
end
