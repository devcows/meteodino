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
# Indexes
#
#  index_weather_stations_on_token  (token)
#

class WeatherStation < ActiveRecord::Base
  attr_accessible :name, :token

  has_many :meteo_datums

  validates :name, presence: true
  validates :token, presence: true


  def get_metadata_last_day
    if Rails.env.development?
      meteo_datums
          .group('temperature_in')
          .select('meteo_data.*, avg(temperature_in) as temperature_in_avg,
                                             max(temperature_in) as temperature_in_max,
                                             min(temperature_in) as temperature_in_min,
                                             avg(humidity_in) as humidity_in_avg,
                                             max(humidity_in) as humidity_in_max,
                                             min(humidity_in) as humidity_in_min,
                                             id as hour,
                                             count(*) as count')
    else
      meteo_datums
          .where('created_at >= DATE_SUB((select max(created_at) from meteo_data), INTERVAL 24 HOUR)')
          .group('HOUR(created_at)')
          .select('meteo_data.*, avg(temperature_in) as temperature_in_avg,
                                             max(temperature_in) as temperature_in_max,
                                             min(temperature_in) as temperature_in_min,
                                             avg(humidity_in) as humidity_in_avg,
                                             max(humidity_in) as humidity_in_max,
                                             min(humidity_in) as humidity_in_min,
                                             HOUR(created_at) as hour,
                                             count(*) as count')
    end
  end

  def get_metadata_custom(date_from, date_to)
    if Rails.env.development?
      meteo_datums
          .where('created_at BETWEEN ? AND ?', date_from, date_to.end_of_day)
          .group('temperature_in')
          .select('meteo_data.*, avg(temperature_in) as temperature_in_avg,
                                             max(temperature_in) as temperature_in_max,
                                             min(temperature_in) as temperature_in_min,
                                             avg(humidity_in) as humidity_in_avg,
                                             max(humidity_in) as humidity_in_max,
                                             min(humidity_in) as humidity_in_min,
                                             id as hour,
                                             count(*) as count')
    else
      meteo_datums
          .where('created_at BETWEEN ? AND ?', date_from, date_to.end_of_day)
          .group('HOUR(created_at)')
          .select('meteo_data.*, avg(temperature_in) as temperature_in_avg,
                                             max(temperature_in) as temperature_in_max,
                                             min(temperature_in) as temperature_in_min,
                                             avg(humidity_in) as humidity_in_avg,
                                             max(humidity_in) as humidity_in_max,
                                             min(humidity_in) as humidity_in_min,
                                             HOUR(created_at) as hour,
                                             count(*) as count')
    end
  end

end
