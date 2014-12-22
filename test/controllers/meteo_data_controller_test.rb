require 'test_helper'

class MeteoDataControllerTest < ActionController::TestCase
  setup do
    @meteo_datum = meteo_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meteo_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meteo_datum" do
    assert_difference('MeteoDatum.count') do
      post :create, meteo_datum: { pressure: @meteo_datum.pressure, temperature: @meteo_datum.temperature }
    end

    assert_redirected_to meteo_datum_path(assigns(:meteo_datum))
  end

  test "should show meteo_datum" do
    get :show, id: @meteo_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meteo_datum
    assert_response :success
  end

  test "should update meteo_datum" do
    patch :update, id: @meteo_datum, meteo_datum: { pressure: @meteo_datum.pressure, temperature: @meteo_datum.temperature }
    assert_redirected_to meteo_datum_path(assigns(:meteo_datum))
  end

  test "should destroy meteo_datum" do
    assert_difference('MeteoDatum.count', -1) do
      delete :destroy, id: @meteo_datum
    end

    assert_redirected_to meteo_data_path
  end
end
