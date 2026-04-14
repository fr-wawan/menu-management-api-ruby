class Api::V1::MenuItemsController < ApplicationController
  before_action :set_restaurant, only: %i[index create]
  before_action :set_menu_item, only: %i[update destroy]
  before_action :validate_category_param, only: :index

  def index
    @menu_items = @restaurant.menu_items
      .by_category(params[:category])
      .by_name(params[:search])
      .page(params[:page]).per(10)

    render json: {
      data: @menu_items,
      meta: {
        current_page: @menu_items.current_page,
        total_pages: @menu_items.total_pages,
        total_count: @menu_items.total_count
      }
    }
  end

  def create
    @menu_item = @restaurant.menu_items.new(menu_item_params)

    if @menu_item.save
      render json: @menu_item, status: :created
    else
      render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item
    else
      render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def validate_category_param
    return unless params[:category].present? && !MenuItem.categories.key?(params[:category])

    render json: {
      errors: [ "Invalid category. Valid categories are: #{MenuItem.categories.keys.join(", ")}" ]
    }, status: :unprocessable_entity
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :category, :is_available)
  end
end
