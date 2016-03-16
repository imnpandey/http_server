require 'rspec'
require_relative '../comment'

RSpec.describe Comment do
  let(:read_all_comments) do
    data = ["GET", "/comments", {}]
    Comment.new(data)
  end

  let(:read_specific_comment) do
    data = ["GET", "/comments/1", {}]
    Comment.new(data)
  end

  let(:insert_comment) do
    data = ["POST", "/form_submit", {
              "name"=>"test",
              "email"=>"test@nav.com",
              "comments"=>"test comment"
            }]
    Comment.new(data)
  end

  describe '#read' do
    it 'returns all the comments' do
      expect(read_all_comments.read_comments).to eq("ok")
    end

    it 'returns specific comment' do
      value = "<table><tr><td><a href='/comments/1'>1</a></td>" \
              "<td>Navneet Pandey</td><td>npandey057@gmail.com</td>" \
              "<td>Ola!!</td></tr></table>"
      expect(read_specific_comment.read_comments).to eq(value)
    end
  end

  describe '#insert' do
    it 'inserts a comment data' do
      expect(insert_comment.create).to eq('Data Entered Successfully!')
    end
  end
end
