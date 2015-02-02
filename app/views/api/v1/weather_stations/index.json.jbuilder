json.array!(@weather_stations) do |ws|
  json.extract! ws, :id, :name, :str_created_at
  json.url api_v1_weather_station_url(ws, format: :json)
  json.last_meteo_datum ws.last_meteo_datum, :temperature_in, :humidity_in, :str_created_at
  json.total_meteo_data ws.meteo_datums.count
  json.meteo_data api_v1_weather_station_meteo_data_url(ws, format: :json)
end
