class API::V1::MeteoDataController < ApiApplicationController
  before_action :set_meteo_datum, only: [:show, :edit, :update, :destroy]

  # GET /meteo_data
  # GET /meteo_data.json
  def index
    @weather_station = WeatherStation.find(params[:weather_station_id])
    render 'api/v1/meteo_data/index', params: @weather_station
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

    if @meteo_datum.save
      render json: @meteo_datum, status: :created, location: @meteo_datum
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
    params.require(:meteo_data).permit(:weather_station_id, :temperature, :humidity)
  end
end
