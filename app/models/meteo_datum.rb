# == Schema Information
#
# Table name: meteo_data
#
#  id                 :integer          not null, primary key
#  weather_station_id :integer
#  temperature        :float
#  humidity           :float
#  created_at         :datetime
#  updated_at         :datetime
#

class MeteoDatum < ActiveRecord::Base
  attr_accessible :weather_station_id, :temperature, :humidity

  belongs_to :weather_station
end
