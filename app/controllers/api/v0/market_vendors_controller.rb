class Api::V0::MarketVendorsController < ApplicationController

  def create
    begin
      vendor = Vendor.find(params[:vendor_id])
      market = Market.find(params[:market_id])
      market_vendor = MarketVendor.new(market_vendor_params)

      if market_vendor.save
        render json: { message: "MarketVendor created successfully." }, status: :created
      else
        render json: { errors: market_vendor.errors }, status: 422
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  private
  def market_vendor_params
    params.require(:market_vendor).permit(:market_id,
                                          :vendor_id
                                          )
  end
end