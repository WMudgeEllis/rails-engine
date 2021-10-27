class Api::V1::RevenueController < ApplicationController


  def merchant_revenue
    merchant = Merchant.find(params[:id])
    render json: RevenueSerializer.merchant_revenue(merchant)
  end

  def most_revenue
    if params[:quantity].present?
      render json: RevenueSerializer.most_revenue(params[:quantity])
    else
      render json: { error: {} }, status: 400
    end
  end
end
