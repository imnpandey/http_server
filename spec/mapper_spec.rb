require 'rspec'
require_relative '../lib/server/mapper'

RSpec.describe Mapper do

  context "GET" do
    let(:static) do
      data = ["GET", "/home", {}]
      Mapper.new.process_request(data)
    end

    let(:not_found) do
      data = ["GET", "/homeless", {}]
      Mapper.new.process_request(data)
    end

    let(:dynamic) do
      data = ["GET", "/comments/1", {}]
      Mapper.new.process_request(data)
    end

    let(:dynamic_not_found) do
      data = ["GET", "/comments/200", {}]
      Mapper.new.process_request(data)
    end

    it "returns static content" do
      expect(static).to eq(open("app/public/home.html").read)
    end

    it "returns 404 static content" do
      expect(not_found).to eq("Not Found")
    end

    it "returns dynamic content" do
      content = "<table><tr><td><a href='/comments/1'>1</a></td>" \
                "<td>Navneet Pandey</td><td>npandey057@gmail.com</td>" \
                "<td>Ola!!</td></tr></table>"
      expect(dynamic).to eq(content)
    end

    it "returns 404 dynamic content" do
      expect(dynamic_not_found).to eq("Not Found")
    end
  end
end
