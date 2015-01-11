class API::V1::MeteoDataController < ApiApplicationController
  before_action :set_meteo_datum, only: [:show, :edit, :update, :destroy]

  # GET /meteo_data
  # GET /meteo_data.json
  def index
    @weather_station = WeatherStation.find(params[:weather_station_id])
    @meteo_data = Array.new
    @meteo_data = @weather_station.meteo_datums.order('created_at desc').limit(100) unless @weather_station.blank?

    render 'api/v1/meteo_data/index', params: [@weather_station, @meteo_data]
  end

  # GET /meteo_data/1
  # GET /meteo_data/1.json
  def show
    render 'api/v1/meteo_data/show', params: @meteo_datum
  end

  # POST /meteo_data
  # POST /meteo_data.json
  def create
    @meteo_datum = MeteoDatum.new(meteodatum_params)
    @meteo_datum.weather_station_id = params[:weather_station_id]

    if @meteo_datum.save
      render json: @meteo_datum, status: :created
    else
      render json: @meteo_datum.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meteo_datum
    @meteo_datum = MeteoDatum.find(params[:id])
  end

  def meteodatum_params
    params.require(:meteo_data).permit(:token, :temperature_in, :humidity_in, :dew_point_in)
  end
end
