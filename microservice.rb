require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require './services/distance'
require './services/geocoordinates'
require 'json'
require 'dotenv'
Dotenv.load

class Microservice < Sinatra::Base

  post '/locations' do
    close_gear = gear_within_distance(params)
    gear_with_coordinates(close_gear).to_json
  end

  post '/user_location' do
    geocoordinates = Geocoordinates.new
    geocoordinates.get_location(user_location(params)).to_json
  end

  def gear_with_coordinates(close_gear)
    geocoordinates = Geocoordinates.new
    geocoordinates.get_coordinates(close_gear)
  end

  def gear_within_distance(params)
    distance = parsed_items(params).first["attributes"]["distance"]
    distance_service = Distance.new
    distance_service.filter_distance(parsed_items(params), user_location(params), distance)
  end

  def parsed_items(params)
    JSON.parse(params["items"])["data"]
  end

  def user_location(params)
    parsed_items(params).first["attributes"]["user_location"]
  end

end
