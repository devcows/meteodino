# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ws = WeatherStation.create(name: 'Arduino hall', token: 'test_token')

r = Random.new
150.times do
  tmp = r.rand(-40..40)
  hum = r.rand(0..100)
  dew = r.rand(0..100)

  MeteoDatum.create(:weather_station_id => ws.id, :token => ws.token, :temperature_in => tmp, :humidity_in => hum, :dew_point_in => dew)
end
