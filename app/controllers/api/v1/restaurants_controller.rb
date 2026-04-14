class Api::V1::RestaurantsController < ApplicationController
  before_action :authenticate_request, only: %i[create update destroy]
  before_action :set_restaurant, only: %i[show update destroy]

  def index
    render json: Restaurant.cached_index(params[:page] || 1)
  end

  def show
    render json: @restaurant.cached_show
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      render json: @restaurant, status: :created
    else
      render json: {errors: @restaurant.errors.full_messages}, status: :unprocessable_content
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant
    else
      render json: {errors: @restaurant.errors.full_messages}, status: :unprocessable_content
    end
  end

  def destroy
    @restaurant.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.includes(:menu_items).find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone, :opening_hours)
  end
end
