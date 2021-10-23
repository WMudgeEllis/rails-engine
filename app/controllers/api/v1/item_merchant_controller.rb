class Api::V1::ItemMerchantController < ApplicationController

  def show
    item = Item.find(params[:item_id])
    merchant = item.merchant
    render json: MerchantsSerializer.merchant_show(merchant.id)
  end
end
