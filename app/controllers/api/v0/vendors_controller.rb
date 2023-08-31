class Api::V0::VendorsController < ApplicationController
  
  def index
    begin
      market = Market.find(params[:market_id])
      render json: VendorSerializer.new(market.vendors)
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  def show
    begin
      vendor = Vendor.find(params[:id])
      render json: VendorSerializer.new(vendor)
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  def create
    vendor = Vendor.new(vendor_params)

    unless [true, false].include?(params[:vendor][:credit_accepted])
      render json: { errors: "Credit accepted must be a boolean" }, status: 400
    end

    if vendor.save
      render json: VendorSerializer.new(vendor), status: :created
    else
      render json: { errors: vendor.errors }, status: 400
    end
  end
  
  def update
    begin
      vendor = Vendor.find(params[:id])
      if vendor.update(vendor_params)
        render json: VendorSerializer.new(vendor)
      else
        render json: { errors: vendor.errors }, status: 400
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  def destroy
    begin
      vendor = Vendor.find(params[:id])
      vendor.destroy
      render json: { message: 'Vendor successfully deleted.' }, status: :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  private
  def vendor_params
    params.require(:vendor).permit(:name,
                                   :description,
                                   :contact_name,
                                   :contact_phone,
                                   :credit_accepted
    )
  end
end