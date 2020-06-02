class Distance

  def filter_distance(gear_items, location, distance)
    close_gear = gear_items.find_all do |gear_item|
      distance(gear_item, location) < distance.to_i
    end
    close_gear
  end

  def distance(gear_item, location)
    conn = Faraday.get("https://maps.googleapis.com/maps/api/distancematrix/json") do |f|
      f.params['units'] = 'imperial'
      f.params['origins'] = location
      f.params['destinations'] = gear_item[:attributes][:location]
      f.params['key'] = ENV['MAPS_KEY']
    end
    json = JSON.parse(conn.body, symbolize_names: true)
    json[:rows].first[:elements].first[:distance][:text].to_i
  end

end
