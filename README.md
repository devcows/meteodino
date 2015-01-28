Dependencies:

-Rubymine

-RVM (mac or linux) => http://rvm.io/rvm/install

Install RVM (development version):

	\curl -sSL https://get.rvm.io | bash

-Ruby 2.0

	rvm install 2.0


If (mac or linux):

	rvm use 2.0
	rvm gemset create meteodino


Enter to project directory:

	bundle install --without production
	bower install

	rake db:create
	rake db:migrate
	rake db:seed #load data
	rails s


Test:

	curl -H "Content-Type:application/json" -H "Accept:application/json" \
        -d '{ "meteo_data" : {"token" : "test_token", "humidity_in" : "23", "temperature_in" : "45", "dew_point_in": "36"} }' localhost:3000/api/v1/weather_stations/1/meteo_data


API:
                                                      
	GET        /api/v1/weather_stations/:weather_station_id/meteo_data_last_day
	GET        /api/v1/weather_stations/:weather_station_id/meteo_data
	POST      /api/v1/weather_stations/:weather_station_id/meteo_data
	GET        /api/v1/weather_stations/:weather_station_id/meteo_data/:id
	GET        /api/v1/weather_stations
	GET        /api/v1/weather_stations/:id