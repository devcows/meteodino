class API::V1::WeatherStationsController < ApiApplicationController
  before_action :set_weather_station, only: [:show, :edit, :update, :destroy]

  # GET /weather_stations
  # GET /weather_stations.json
  def index
    @weather_stations = WeatherStation.all
    render 'api/v1/weather_stations/index', params: @weather_stations
  end

  # GET /weather_stations/1
  # GET /weather_stations/1.json
  def show
    render 'api/v1/weather_stations/show', params: @weather_station
  end

  def meteo_data_last_day
    @weather_station = WeatherStation.find(params[:weather_station_id])
    @meteo_data = @weather_station.meteo_datums
                      .where('created_at >= DATE_SUB((select max(created_at) from meteo_data), INTERVAL 24 HOUR)')
                      .group('HOUR(created_at)')
                      .select('meteo_data.*, avg(temperature_in) as temperature_in_avg,
                                             max(temperature_in) as temperature_in_max,
                                             min(temperature_in) as temperature_in_min,
                                             avg(humidity_in) as humidity_in_avg,
                                             max(humidity_in) as humidity_in_max,
                                             min(humidity_in) as humidity_in_min,
                                             HOUR(created_at) as hour,
                                             count(*) as count')

    render 'api/v1/meteo_data/index', params: [@weather_station, @meteo_data]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_weather_station
    @weather_station = WeatherStation.find(params[:id])
  end
end
