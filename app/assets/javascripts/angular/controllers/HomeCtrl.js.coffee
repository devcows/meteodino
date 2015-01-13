# app/assets/javascripts/angular/controllers/HomeCtrl.js.coffee

round_float = (value) ->
  Math.round(value * 100) / 100

@meteodino.controller 'HomeCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->

  $scope.update_station = () ->
    $scope.last_day_temp_avg = ""
    $scope.last_day_hum_avg = ""
    $scope.weather_station_data_last_day = []

    $('#weather_station_results').hide();
    $('.ajax-loader').show();

    $.plot($("#placeholder"), [ [[0, 0], [1, 1]] ], { yaxis: { max: 1 } });

    if $scope.weather_station != ""
      $('#weather_station_results').show();
      $http.get('./api/v1/weather_stations/' + $scope.weather_station + '/meteo_data_last_day').success((data) ->
        $scope.weather_station_data_last_day = data

        tmp_avg = 0
        hum_avg = 0
        for i in [0..data.length - 1]
          tmp_avg += data[i].temperature_in_avg
          hum_avg += data[i].humidity_in_avg
        #alert(data[i])

        $scope.last_day_temp_avg = round_float(tmp_avg / data.length)
        $scope.last_day_hum_avg = round_float(hum_avg / data.length)

        $('.ajax-loader-last-day').hide();
      )


  #Main scope
  $scope.weather_stations = []
  $scope.weather_station_data_last_day = []

  $http.get('./api/v1/weather_stations').success((data) ->
    $scope.weather_stations = data
  )
]