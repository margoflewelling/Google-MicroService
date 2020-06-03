require './microservice.rb'
require 'rack/test'


describe "My Sinatra Application" do
  include Rack::Test::Methods
  def app
    Microservice.new
  end

  it "should return items with coordinates" do
   json = {"data"=>
      [{"id"=>"1137", "type"=>"gear_item", "attributes"=>{"id"=>1137, "name"=>"Helmet", "location"=>"1662 South Pearl St, Denver, CO 80210", "user_location"=>"Denver, CO", "distance"=>"15"}},
       {"id"=>"1139", "type"=>"gear_item", "attributes"=>{"id"=>1139, "name"=>"Purple Helmet", "location"=>"1300 South Pearl St, Denver, CO 80210", "user_location"=>"Denver, CO", "distance"=>"15"}},
       {"id"=>"1141", "type"=>"gear_item", "attributes"=>{"id"=>1141, "name"=>"Cool Helmet", "location"=>"813 W Mulberry St, Fort Collins, CO 80521", "user_location"=>"Denver, CO", "distance"=>"15"}}]}

    get '/locations', :items => json
    expect(last_response).to be_ok
    items = JSON.parse(last_response.body)
    expect(items.count).to eq(2)
    expect(items.first["attributes"].has_key?("coordinates")).to eq(true)
  end

  it "should return user_location endpoint" do
    json = {"data"=>
       [{"id"=>"1137", "type"=>"gear_item", "attributes"=>{"id"=>1137, "name"=>"Helmet", "location"=>"1662 South Pearl St, Denver, CO 80210", "user_location"=>"Denver, CO", "distance"=>"15"}},
        {"id"=>"1139", "type"=>"gear_item", "attributes"=>{"id"=>1139, "name"=>"Purple Helmet", "location"=>"1300 South Pearl St, Denver, 80210 CO", "user_location"=>"Denver, CO", "distance"=>"15"}},
        {"id"=>"1141", "type"=>"gear_item", "attributes"=>{"id"=>1141, "name"=>"Cool Helmet", "location"=>"813 W Mulberry St, Fort Collins, CO 80521", "user_location"=>"Denver, CO", "distance"=>"15"}}]}
    get '/user_location', :items => json
    expect(last_response).to be_ok
    location = JSON.parse(last_response.body)
    expect(location.is_a? Hash).to eq(true)
    expect(location.has_key?("latitude")).to eq(true)
    expect(location.has_key?("longitude")).to eq(true)
  end
end
