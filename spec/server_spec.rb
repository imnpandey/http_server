require 'rspec'
require 'httparty'
require_relative '../server/server'
require_relative '../comment'

RSpec.describe Server do
  include HTTParty

  let(:root) do
    response = HTTParty.get('http://localhost:3000/')
    response.body
  end

  let(:static) do
    response = HTTParty.get('http://localhost:3000/home')
    response.body
  end

  describe '#static' do
    it "returns root" do
      expect(root).to eq(open("public/index.html").read)
    end

    it "returns static content" do
      expect(static).to eq(open("public/home.html").read)
    end
  end

  describe '#dynamic' do
    describe '#single_comment' do
      before(:all) do
        data = ["GET", "/comments/1", {}]
        @single_comment = Comment.new(data).read_comments
      end

      let(:single_comment) do
        response = HTTParty.get('http://localhost:3000/comments/1')
        response.body
      end

      it 'returns single content' do
        expect(single_comment).to eq(@single_comment)
      end
    end

    describe '#all_comment' do
      before(:all) do
        data = ["GET", "/comments", {}]
        @all_comment = Comment.new(data).read_comments
      end

      let(:all_comment) do
        response = HTTParty.get('http://localhost:3000/comments')
        response.body
      end

      it 'returns all content' do
        expect(all_comment).to eq(@all_comment)
      end
    end

    describe '#post comment' do
      before(:context) do
         data = ["POST", "/form_submit", {
              "name"=>"test",
              "email"=>"test@nav.com",
              "comments"=>"test comment spec"
            }]
        @comment = Comment.new(data).create
      end
    end
  end
end
