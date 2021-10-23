class Api::V1::ItemsController < ApplicationController

  def index
    page = params[:page].to_i if params[:page].present?
    per_page = params[:per_page].to_i if params[:per_page].present?

    render json: ItemsSerializer.item_index(page, per_page)
  end

end
