# == Schema Information
#
# Table name: meteo_data
#
#  id                 :integer          not null, primary key
#  weather_station_id :integer
#  temperature_in     :float(24)
#  humidity_in        :float(24)
#  dew_point_in       :float(24)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class MeteoDatumTest < ActiveSupport::TestCase

  test 'should not save meteodatum without params' do
    meteo = MeteoDatum.new
    assert_not meteo.save
  end

  test 'should save meteodatum with params' do
    meteo = MeteoDatum.new

    meteo.weather_station_id = 1
    meteo.temperature_in = 1
    meteo.dew_point_in = 1
    meteo.token = 'MyString'

    assert meteo.save
  end
end
