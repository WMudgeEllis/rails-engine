class Api::V1::RevenueController < ApplicationController


  def merchant_revenue
    merchant = Merchant.find(params[:id])
    render json: MerchantsSerializer.merchant_revenue(merchant)
  end

  def most_revenue
    render json: MerchantsSerializer.most_revenue(params[:quantity])
  end
end
