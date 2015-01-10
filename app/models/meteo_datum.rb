# == Schema Information
#
# Table name: meteo_data
#
#  id                 :integer          not null, primary key
#  weather_station_id :integer
#  temperature_in     :float
#  humidity_in        :float
#  dew_point_in       :float
#  created_at         :datetime
#  updated_at         :datetime
#

class MeteoDatum < ActiveRecord::Base
  attr_accessible :weather_station_id, :temperature_in, :humidity_in, :dew_point_in, :token
  attr_accessor :temperature_in_avg, :temperature_in_max, :temperature_in_min, :token

  belongs_to :weather_station

  validate :check_token
  validate :weather_station_id, presence: true
  validate :humidity_in, presence: true
  validate :dew_point_in, presence: true

  def check_token
    ws = WeatherStation.find_by_token(self.token)
    if ws.nil? || self.weather_station_id.nil? || ws.id != self.weather_station_id
      errors.add(:weather_station, 'is incorrect!')
    end
  end

end
