require 'sinatra/base'
require './services/distance'
require './services/geocoordinates'

class Microservice < Sinatra::Base

  get '/locations' do
    require "pry"; binding.pry
    items = params["items"]["data"]
    distance = Distance.new
    location = items.first["attributes"]["user_location"]
    distance = items.first["attributes"]["distance"]
    close_gear = distance.filter_distance(items, location, distance)
    geocoordinates = Geocoordinates.new
    item_locations = geocoordinates.get_coordinates(close_gear)
  end

end
