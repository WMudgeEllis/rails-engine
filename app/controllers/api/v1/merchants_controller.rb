  class Api::V1::MerchantsController < ApplicationController

    def index
      if params[:page].present?
        page = params[:page].to_i
      else
        page = nil
      end

      if params[:per_page].present?
        per_page = params[:per_page].to_i
      else
        per_page = nil
      end
      render json: MerchantsSerializer.merchant_index(page, per_page)

    end

  end
