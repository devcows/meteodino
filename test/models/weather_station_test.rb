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
  # test "the truth" do
  #   assert true
  # end
end
