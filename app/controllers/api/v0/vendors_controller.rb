class Api::V0::VendorsController < ApplicationController
  
  def index
    render json: VendorSerializer.new(Vendor.all)
  end

  # def show
  #  vendor = Vendor.find_by(id: params[:id])
  #  if market.nil?
  #     render json: { errors: "The ID provided cannot be found" }, status: :not_found
  #   else
  #     render json: MarketSerializer.new(market)
  #   end
  # end
end