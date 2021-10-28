class Api::V1::MerchantItemsController < ApplicationController
  def index
    render json: MerchantsSerializer.merchant_items(params[:merchant_id])
  end
end
