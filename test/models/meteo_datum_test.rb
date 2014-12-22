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

require 'test_helper'

class MeteoDatumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
