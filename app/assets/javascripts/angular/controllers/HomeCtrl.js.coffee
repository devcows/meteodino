# app/assets/javascripts/angular/controllers/HomeCtrl.js.coffee

@meteodino.controller 'HomeCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->

  $scope.update_station = () ->
    $scope.weather_station_data = []

    if $scope.weather_station != ""
      $http.get('./api/v1/weather_stations/' + $scope.weather_station + '/meteo_data').success((data) ->
        $scope.weather_station_data = data
      )

  $scope.weather_stations = []
  $scope.weather_station_data = []
  
  $http.get('./api/v1/weather_stations').success((data) ->
    $scope.weather_stations = data
  )
]