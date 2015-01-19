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
    @meteo_data = @weather_station.get_metadata_last_day

    render 'api/v1/meteo_data/index', params: [@weather_station, @meteo_data]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_weather_station
    @weather_station = WeatherStation.find(params[:id])
  end
end
