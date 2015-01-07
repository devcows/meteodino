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

require 'test_helper'

class WeatherStationTest < ActiveSupport::TestCase
  test 'should not save weather station without params' do
    ws = WeatherStation.new
    assert_not ws.save
  end

  test 'should save weather station with params' do
    ws = WeatherStation.new

    ws.name = 'MyString'
    ws.token = 'MyString'

    assert ws.save
  end
end
