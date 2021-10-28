class Api::V1::ItemsController < ApplicationController
  def index
    page = params[:page].to_i if params[:page].present?
    per_page = params[:per_page].to_i if params[:per_page].present?

    render json: ItemsSerializer.item_index(page, per_page)
  end

  def find
    if bad_params?(params)
      render json: { error: {} }, status: 400
    elsif params[:name].present?
      item = Item.name_search(params[:name].downcase)
      render json: ItemsSerializer.item_show(item.id) if item
      render json: { data: {} } if item.nil?
    elsif params[:min_price].present?
      item = Item.min_price_search(params[:min_price])
      render json: ItemsSerializer.item_show(item.id) if item
      render json: { data: {} } if item.nil?
    elsif params[:max_price].present?
      item = Item.max_price_search(params[:max_price])
      render json: ItemsSerializer.item_show(item.id)
    else
      render json: { data: {} }
    end
  end

  def show
    render json: ItemsSerializer.item_show(params[:id])
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemsSerializer.item_show(item.id), status: 201
    else
      render json: { error: item.errors.full_messages.to_sentence }
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemsSerializer.item_show(item.id)
    else
      render json: { data: [] }, status: 404
    end
  end

  def destroy
    item = Item.find(params[:id])
    invoices = item.invoices_only_item
    invoices.each { |invoice| invoice.destroy }
    item.destroy
  end

  private

  def bad_params?(params)
    if params.keys.length > 3
      return true
    elsif params[:min_price] && params[:min_price].to_i < 0
      return true
    elsif params[:max_price] && params[:max_price].to_i < 0
      return true
    end

    false
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
