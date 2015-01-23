# app/assets/javascripts/angular/controllers/HomeCtrl.js.coffee
COLOR_MIN = "#69E7FF"
COLOR_MED = "#DBD700"
COLOR_MAX = "#FF415A"


options_tmp = {
  colors: [COLOR_MIN, COLOR_MED, COLOR_MAX],
  legend: {show: true, noColumns: 0},
  yaxis: {
    tickFormatter: suffixFormatter = (val, axis) ->
      return String(val) + "&#8451;"
  },
  xaxis: {
    tickFormatter: suffixFormatter = (val, axis) ->
      return String(val) + "h"
  }
}

options_hum = {
  colors: [COLOR_MIN, COLOR_MED, COLOR_MAX],
  legend: {show: true, noColumns: 0}
  yaxis: {
    tickFormatter: suffixFormatter = (val, axis) ->
      return String(val) + "%"
  },
  xaxis: {
    tickFormatter: suffixFormatter = (val, axis) ->
      return String(val) + "h"
  }
}

round_float = (value) ->
  Math.round(value * 100) / 100

calculate_tmps = (data) ->
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

  if data.length > 0
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


  [minimal_tmp, tmp_avg, maximum_tmp, min_tmp, avg_tmp, max_tmp, minimal_hum, hum_avg, maximum_hum, min_hum, avg_hum,
   max_hum]

@meteodino.controller 'HomeCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $scope.update_custom = () ->
    $('#data-custom-error').hide()
    $('#data-custom').show()
    $('.ajax-loader-custom').show()

    val_previous = $("#date_from").val()
    val_today = $("#date_to").val()

    $http.get('./api/v1/weather_stations/' + $scope.weather_station + '/meteo_data_custom',
      {params: {date_from: val_previous, date_to: val_today}}).success((data) ->
      $scope.weather_station_data_custom = data

      if data.length > 0
        [minimal_tmp, tmp_avg, maximum_tmp, min_tmp, avg_tmp, max_tmp, minimal_hum, hum_avg, maximum_hum, min_hum, avg_hum, max_hum] = calculate_tmps(data)

        $scope.custom_temp_avg = round_float(tmp_avg / data.length)
        $scope.custom_hum_avg = round_float(hum_avg / data.length)
        $scope.custom_temp_max = maximum_tmp
        $scope.custom_temp_min = minimal_tmp
        $scope.custom_hum_max = maximum_hum
        $scope.custom_hum_min = minimal_hum

        $.plot($("#placeholder-custom-tmp"),
          [{label: "Min", data: min_tmp}, {label: "Avg", data: avg_tmp}, {label: "Max", data: max_tmp}], options_tmp)
        $.plot($("#placeholder-custom-hum"),
          [{label: "Min", data: min_hum}, {label: "Avg", data: avg_hum}, {label: "Max", data: max_hum}], options_hum)

      else
        $('#data-custom').hide()
        $('#data-custom-error').show()

      $('.ajax-loader-custom').hide()
    )

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

    $("#placeholder-custom-tmp").html("")
    $("#placeholder-custom-hum").html("")

    $('#weather_station_results').hide()
    $('#data-custom').show()
    $('.ajax-loader').show()

    if $scope.weather_station != ""
      $('#weather_station_results').show()
      $http.get('./api/v1/weather_stations/' + $scope.weather_station + '/meteo_data_last_day').success((data) ->
        $scope.weather_station_data_last_day = data

        [minimal_tmp, tmp_avg, maximum_tmp, min_tmp, avg_tmp, max_tmp, minimal_hum, hum_avg, maximum_hum, min_hum, avg_hum, max_hum] = calculate_tmps(data)

        $scope.last_day_temp_avg = round_float(tmp_avg / data.length)
        $scope.last_day_hum_avg = round_float(hum_avg / data.length)
        $scope.last_day_temp_max = maximum_tmp
        $scope.last_day_temp_min = minimal_tmp
        $scope.last_day_hum_max = maximum_hum
        $scope.last_day_hum_min = minimal_hum

        $.plot($("#placeholder-last-day-tmp"),
          [{label: "Min", data: min_tmp}, {label: "Avg", data: avg_tmp}, {label: "Max", data: max_tmp}], options_tmp)
        $.plot($("#placeholder-last-day-hum"),
          [{label: "Min", data: min_hum}, {label: "Avg", data: avg_hum}, {label: "Max", data: max_hum}], options_hum)


        $('.ajax-loader-last-day').hide()

        date = new Date()
        date_previous = new Date(date.getTime() - 7 * 24 * 60 * 60 * 1000);

        val_today = date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear()
        val_previous = date_previous.getDate() + '/' + (date_previous.getMonth() + 1) + '/' + date_previous.getFullYear()

        $("#date_from").val(val_previous)
        $("#date_to").val(val_today)

        $scope.update_custom()
      )


  #Main scope
  $('#weather_station_results').hide()
  $('#data-custom-error').hide()
  $('.datepicker').datepicker({dateFormat: 'dd/mm/yy'})
  $scope.weather_stations = []
  $scope.weather_station_data_last_day = []

  $http.get('./api/v1/weather_stations').success((data) ->
    $scope.weather_stations = data
  )

  $scope.color_min = COLOR_MIN
  $scope.color_avg = COLOR_MED
  $scope.color_max = COLOR_MAX
]