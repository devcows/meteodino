Dependencies:
-Rubymine
-RVM (mac or linux) => http://rvm.io/rvm/install

Install RVM (development version):
	\curl -sSL https://get.rvm.io | bash

-Ruby 2.0
Install 2.0:
	rvm install 2.0


If (mac or linux):
	rvm use 2.0
	rvm gemset create meteodino


Enter to project directory:
	bundle install --without production

	rake db:create
	rake db:migrate
	rake db:seed #load data
	rails s


Test:
	curl -H "Content-Type:application/json" -H "Accept:application/json" \
        -d '{ "meteo_data" : {"token" : "test_token", "humidity" : "23", "temperature" : "45"} }' \
        localhost:3000/api/v1/weather_stations/1/meteo_data


                            Prefix Verb URI Pattern                                                           Controller#Action
 api_v1_weather_station_meteo_data GET  /api/v1/weather_stations/:weather_station_id/meteo_data(.:format)     api/v1/meteo_data#index {:format=>"json"}
                                   POST /api/v1/weather_stations/:weather_station_id/meteo_data(.:format)     api/v1/meteo_data#create {:format=>"json"}
api_v1_weather_station_meteo_datum GET  /api/v1/weather_stations/:weather_station_id/meteo_data/:id(.:format) api/v1/meteo_data#show {:format=>"json"}
           api_v1_weather_stations GET  /api/v1/weather_stations(.:format)                                    api/v1/weather_stations#index {:format=>"json"}
            api_v1_weather_station GET  /api/v1/weather_stations/:id(.:format)                                api/v1/weather_stations#show {:format=>"json"}
