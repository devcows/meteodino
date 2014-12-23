# == Schema Information
#
# Table name: meteo_data
#
#  id                 :integer          not null, primary key
#  weather_station_id :integer
#  temperature        :float
#  humidity           :float
#  dew_point          :float
#  created_at         :datetime
#  updated_at         :datetime
#

class MeteoDatum < ActiveRecord::Base
  attr_accessible :weather_station_id, :temperature, :humidity, :dew_point, :token
  attr_accessor :token

  belongs_to :weather_station

  validate :check_token

  def check_token
    ws = WeatherStation.find_by_token(self.token)
    if ws.nil? || self.weather_station_id.nil? || ws.id != self.weather_station_id
      errors.add(:weather_station, 'is incorrect!')
    end
  end

end
