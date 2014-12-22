json.array!(@weather_stations) do |weather_station|
  json.extract! weather_station, :id, :name
  json.url api_v1_weather_station_url(weather_station, format: :json)
  json.meteo_data api_v1_weather_station_meteo_data_url(weather_station, format: :json)
end
