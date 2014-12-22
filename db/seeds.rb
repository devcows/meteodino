# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ws = WeatherStation.create(name: 'Arduino hall', token: 'dsadasdasdsada')

r = Random.new
150.times do
  tmp = r.rand(-40..40)
  hum = r.rand(0..100)

  MeteoDatum.create(:weather_station_id => ws.id, :temperature => tmp, :humidity => hum)
end
