json.array!(@meteo_data) do |meteo_datum|
  json.extract! meteo_datum, :id, :temperature_in, :humidity_in, :dew_point_in, :created_at

  unless meteo_datum.attributes['temperature_in_avg'].blank?
    json.temperature_in_avg meteo_datum.attributes['temperature_in_avg'].round(2)
  end

  unless meteo_datum.attributes['temperature_in_max'].blank?
    json.temperature_in_max meteo_datum.attributes['temperature_in_max'].round(2)
  end

  unless meteo_datum.attributes['temperature_in_min'].blank?
    json.temperature_in_min meteo_datum.attributes['temperature_in_min'].round(2)
  end

  json.url api_v1_weather_station_meteo_datum_url(@weather_station, meteo_datum, format: :json)
end
