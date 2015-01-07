# == Schema Information
#
# Table name: weather_stations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class WeatherStation < ActiveRecord::Base
  attr_accessible :name, :token

  has_many :meteo_datums

  validates :name, presence: true
  validates :token, presence: true
end
