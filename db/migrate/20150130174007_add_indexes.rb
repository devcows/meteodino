class AddIndexes < ActiveRecord::Migration
  def change
    add_index :weather_stations, :token

    add_index :meteo_data, :weather_station_id
    add_index :meteo_data, :created_at
  end
end
