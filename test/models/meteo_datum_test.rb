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

require 'test_helper'

class MeteoDatumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
