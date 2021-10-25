  class Api::V1::MerchantsController < ApplicationController

    def index
      page = params[:page].to_i if params[:page].present?
      per_page = params[:per_page].to_i if params[:per_page].present?

      render json: MerchantsSerializer.merchant_index(page, per_page)
    end

    def show
      render json: MerchantsSerializer.merchant_show(params[:id])
    end

    def find
      render json: MerchantsSerializer.merchant_find(params[:name])
    end

  end
