class CreateMeteoData < ActiveRecord::Migration
  def change
    create_table :meteo_data do |t|
      t.integer :weather_station_id
      t.float :temperature_in
      t.float :humidity_in
      t.float :dew_point_in

      t.timestamps
    end
  end
end
