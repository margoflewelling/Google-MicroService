require './microservice.rb'
require 'rack/test'


describe "My Sinatra Application" do
  include Rack::Test::Methods
  def app
    Microservice.new
  end

  it "should return items with coordinates" do
  json = "{\"data\":[{\"id\":\"76\",\"type\":\"gear_item\",\"attributes\":{\"id\":76,\"name\":\"Helmet\",\"location\":\"Denver, CO\",\"user_location\":\"Denver, CO\",\"distance\":\"15\"}},{\"id\":\"78\",\"type\":\"gear_item\",\"attributes\":{\"id\":78,\"name\":\"Purple Helmet\",\"location\":\"Denver, CO\",\"user_location\":\"Denver, CO\",\"distance\":\"15\"}},{\"id\":\"80\",\"type\":\"gear_item\",\"attributes\":{\"id\":80,\"name\":\"Cool Helmet\",\"location\":\"Fort Collins, CO\",\"user_location\":\"Denver, CO\",\"distance\":\"15\"}}]}"
    post '/locations', :items => json
    expect(last_response).to be_ok
    items = JSON.parse(last_response.body)
    require "pry"; binding.pry
    expect(items.count).to eq(2)
    expect(items.first["attributes"].has_key?("coordinates")).to eq(true)
  end

  it "should return user_location endpoint" do
    json = "{\"data\":[{\"id\":\"76\",\"type\":\"gear_item\",\"attributes\":{\"id\":76,\"name\":\"Helmet\",\"location\":\"Denver, CO\",\"user_location\":\"Denver, CO\",\"distance\":\"15\"}},{\"id\":\"78\",\"type\":\"gear_item\",\"attributes\":{\"id\":78,\"name\":\"Purple Helmet\",\"location\":\"Denver, CO\",\"user_location\":\"Denver, CO\",\"distance\":\"15\"}},{\"id\":\"80\",\"type\":\"gear_item\",\"attributes\":{\"id\":80,\"name\":\"Cool Helmet\",\"location\":\"Fort Collins, CO\",\"user_location\":\"Denver, CO\",\"distance\":\"15\"}}]}"

    post '/user_location', :items => json
    expect(last_response).to be_ok
    location = JSON.parse(last_response.body)
    require "pry"; binding.pry
    expect(location.is_a? Hash).to eq(true)
    expect(location.has_key?("latitude")).to eq(true)
    expect(location.has_key?("longitude")).to eq(true)
  end
end
