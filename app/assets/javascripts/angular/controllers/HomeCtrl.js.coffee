# app/assets/javascripts/angular/controllers/HomeCtrl.js.coffee
COLOR_MIN = "#69E7FF"
COLOR_MED = "#DBD700"
COLOR_MAX = "#FF415A"


round_float = (value) ->
  Math.round(value * 100) / 100

@meteodino.controller 'HomeCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->

  $scope.update_station = () ->
    $scope.last_day_temp_avg = ""
    $scope.last_day_hum_avg = ""

    $scope.last_day_temp_max = ""
    $scope.last_day_temp_min = ""
    $scope.last_day_hum_max = ""
    $scope.last_day_hum_min = ""

    $scope.weather_station_data_last_day = []

    $("#placeholder-last-day-tmp").html("")
    $("#placeholder-last-day-hum").html("")

    $('#weather_station_results').hide()
    $('.ajax-loader').show()

    if $scope.weather_station != ""
      $('#weather_station_results').show()
      $http.get('./api/v1/weather_stations/' + $scope.weather_station + '/meteo_data_last_day').success((data) ->
        $scope.weather_station_data_last_day = data
        minimal_tmp = 100
        maximum_tmp = 0

        minimal_hum = 200
        maximum_hum = -10

        tmp_avg = 0
        hum_avg = 0

        min_tmp = []
        avg_tmp = []
        max_tmp = []

        min_hum = []
        avg_hum = []
        max_hum = []

        for i in [0..data.length - 1]
          tmp_avg += data[i].temperature_in_avg
          hum_avg += data[i].humidity_in_avg

          min_tmp.push([data[i].hour, data[i].temperature_in_min])
          avg_tmp.push([data[i].hour, data[i].temperature_in_avg])
          max_tmp.push([data[i].hour, data[i].temperature_in_max])

          min_hum.push([data[i].hour, data[i].humidity_in_min])
          avg_hum.push([data[i].hour, data[i].humidity_in_avg])
          max_hum.push([data[i].hour, data[i].humidity_in_max])

          if minimal_tmp > data[i].temperature_in_min
            minimal_tmp = data[i].temperature_in_min

          if maximum_tmp < data[i].temperature_in_max
            maximum_tmp = data[i].temperature_in_max

          if minimal_hum > data[i].humidity_in_min
            minimal_hum = data[i].humidity_in_min

          if maximum_hum < data[i].humidity_in_max
            maximum_hum = data[i].humidity_in_max


        $scope.last_day_temp_avg = round_float(tmp_avg / data.length)
        $scope.last_day_hum_avg = round_float(hum_avg / data.length)
        $scope.last_day_temp_max = maximum_tmp
        $scope.last_day_temp_min = minimal_tmp
        $scope.last_day_hum_max = maximum_hum
        $scope.last_day_hum_min = minimal_hum


        options_tmp = { colors: [COLOR_MIN, COLOR_MED, COLOR_MAX], legend: {show: false, container: $('#placeholder-last-day-tmp-legend'), position: 'ne'}}
        options_hum = { colors: [COLOR_MIN, COLOR_MED, COLOR_MAX], legend: {show: false, container: $('#placeholder-last-day-hum-legend'), position: 'ne'}}
        $.plot($("#placeholder-last-day-tmp"), [ {label:"Min", data:min_tmp}, {label:"Avg", data:avg_tmp}, {label:"Max", data:max_tmp} ], options_tmp)
        $.plot($("#placeholder-last-day-hum"), [ {label:"Min", data:min_hum}, {label:"Avg", data:avg_hum}, {label:"Max", data:max_hum} ], options_hum)

        $('.ajax-loader-last-day').hide()
        $('.ajax-loader-custom').hide()
      )


  #Main scope
  $('.datepicker').datepicker();
  $scope.weather_stations = []
  $scope.weather_station_data_last_day = []

  $http.get('./api/v1/weather_stations').success((data) ->
    $scope.weather_stations = data
  )
]