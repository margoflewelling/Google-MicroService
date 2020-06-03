require 'rubygems'
require 'sinatra/base'
require './services/distance'
require './services/geocoordinates'
require 'json'
require 'dotenv'
Dotenv.load



class Microservice < Sinatra::Base

  get '/locations' do
    items = params["items"]["data"]
    location = items.first["attributes"]["user_location"]
    distance = items.first["attributes"]["distance"]
    distance_service = Distance.new
    close_gear = distance_service.filter_distance(items, location, distance)
    geocoordinates = Geocoordinates.new
    items_with_coordinates = geocoordinates.get_coordinates(close_gear)
    content_type :json
    items_with_coordinates.to_json
  end

  get '/user_location' do
    city = params["items"]["data"].first["attributes"]["user_location"]
    geocoordinates = Geocoordinates.new
    user_location = geocoordinates.get_location(city)
    content_type :json
    user_location.to_json
  end

end
