class Geocoordinates

  def get_coordinates(gear_items)
    gear_items.each do |gear_item|
      location = get_location(gear_item[:attributes][:location])
      gear_item[:attributes][:coordinates] = location
    end
    gear_items
  end

  def get_location(location)
    conn = Faraday.get("https://maps.googleapis.com/maps/api/geocode/json") do |f|
      f.params['address'] = location
      f.params['key'] = ENV['MAPS_KEY']
    end
    json = JSON.parse(conn.body, symbolize_names: true)
    json[:results].first[:access_points].first[:location]
  end

end
