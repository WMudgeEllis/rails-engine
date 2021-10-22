  class Api::V1::MerchantsController < ApplicationController

    def index
      render json: MerchantsSerializer.merchant_index
    end

  end
