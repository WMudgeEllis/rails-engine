class Api::V1::ItemsController < ApplicationController

  def index
    page = params[:page].to_i if params[:page].present?
    per_page = params[:per_page].to_i if params[:per_page].present?

    render json: ItemsSerializer.item_index(page, per_page)
  end

  def show
    render json: ItemsSerializer.item_show(params[:id])
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemsSerializer.item_show(item.id)
    else
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
