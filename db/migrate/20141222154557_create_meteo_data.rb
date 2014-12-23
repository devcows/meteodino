class CreateMeteoData < ActiveRecord::Migration
  def change
    create_table :meteo_data do |t|
      t.integer :weather_station_id
      t.float :temperature
      t.float :humidity
      t.float :dew_point

      t.timestamps
    end
  end
end
