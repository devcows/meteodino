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

    if $scope.weather_station != ""
      $('#weather_station_results').show();
      $http.get('./api/v1/weather_stations/' + $scope.weather_station + '/meteo_data_last_day').success((data) ->
        $scope.weather_station_data_last_day = data

        tmp_avg = 0
        hum_avg = 0

        min_tmp = []
        avg_tmp = []
        max_tmp = []

        for i in [0..data.length - 1]
          tmp_avg += data[i].temperature_in_avg
          hum_avg += data[i].humidity_in_avg

          min_tmp.push([i, data[i].temperature_in_min])
          avg_tmp.push([i, data[i].temperature_in_avg])
          max_tmp.push([i, data[i].temperature_in_max])


        $scope.last_day_temp_avg = round_float(tmp_avg / data.length)
        $scope.last_day_hum_avg = round_float(hum_avg / data.length)

        $.plot($("#placeholder"), [ min_tmp, avg_tmp, max_tmp ], { });
        $('.ajax-loader-last-day').hide();
      )


  #Main scope
  $scope.weather_stations = []
  $scope.weather_station_data_last_day = []

  $http.get('./api/v1/weather_stations').success((data) ->
    $scope.weather_stations = data
  )
]