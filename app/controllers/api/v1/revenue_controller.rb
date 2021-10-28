class Api::V1::RevenueController < ApplicationController


  def merchant_revenue
    merchant = Merchant.find(params[:id])
    render json: RevenueSerializer.merchant_revenue(merchant)
  end

  def merchant_revenue_list
    if params[:quantity]
      render json: RevenueSerializer.most_revenue(params[:quantity])
    else
      render json: { error: {} }, status: 400
    end
  end

  def unshipped_revenue
    if params[:quantity] && params[:quantity].to_i <= 0
      render json: { error: {} }, status: 400
    elsif params.keys.include?(:quantity) && params[:quantity].nil?
      render json: { error: {} }, status: 400
    else
      render json: RevenueSerializer.unshipped_revenue(params[:quantity])
    end
  end

  def item_revenue_list
    if params[:quantity] && params[:quantity].to_i <= 0
      render json: { error: {} }, status: 400
    elsif params.keys.include?(:quantity) && params[:quantity].nil?
      render json: { error: {} }, status: 400
    else
      render json: RevenueSerializer.item_revenue_list(params[:quantity])
    end
  end
end
