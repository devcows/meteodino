json.array!(@weather_station.meteo_datums) do |meteo_datum|
  json.extract! meteo_datum, :id, :temperature_in, :humidity_in, :dew_point_in
  json.url api_v1_weather_station_meteo_datum_url(@weather_station, meteo_datum, format: :json)
end
