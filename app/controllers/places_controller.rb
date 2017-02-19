class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = BeerweatherApi.fetch_weather_in(params[:city])
    session[:last_city] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]} or no such city"
    else
      render :index
    end
  end

  def show
    @place = BeermappingApi.get_place(session[:last_city], params[:id])
  end

end
