require 'sinatra/base'
require './services/distance'
require './services/geocoordinates'

class Microservice < Sinatra::Base

  get '/locations' do
    items = params["items"]["data"]
    location = items.first["attributes"]["user_location"]
    distance = items.first["attributes"]["distance"]
    require "pry"; binding.pry
    distance_service = Distance.new
    close_gear = distance_service.filter_distance(items, location, distance)
    geocoordinates = Geocoordinates.new
    item_locations = geocoordinates.get_coordinates(close_gear)
  end

end
