class Api::V0::MarketVendorsController < ApplicationController

  def create
    begin
      vendor = Vendor.find(params[:vendor_id])
      market = Market.find(params[:market_id])

      market_vendor = MarketVendor.new(market_id: market.id, vendor_id: vendor.id)

      if market_vendor.save
        render json: { message: "MarketVendor created successfully." }, status: :created
      else
        render json: { errors: [{ detail: "Validation failed: Market vendor association between market with market_id=#{params[:market_id]} and vendor_id=#{params[:vendor_id]} already exists" }] }, status: 422
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  def destroy
    begin
      vendor = Vendor.find(params[:vendor_id])
      market = Market.find(params[:market_id])

      market_vendor = MarketVendor.find_by(market_id: market.id, vendor_id: vendor.id)
      market_vendor.destroy
      head :no_content
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