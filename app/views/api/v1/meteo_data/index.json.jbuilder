json.array!(@weather_station.meteo_datums) do |meteo_datum|
  json.extract! meteo_datum, :id, :temperature, :humidity
  json.url api_v1_weather_station_meteo_datum_url(@weather_station, meteo_datum, format: :json)
end
