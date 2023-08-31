class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    begin
      market = Market.find(params[:id])
      render json: MarketSerializer.new(market)
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  def search
    markets = Market.all
    if params[:state] && !params[:city] && !params[:name]
      markets = markets.where("state ILIKE ?", "%#{params[:state]}%")
    end

    if params[:name] && !params[:city] && !params[:state]
      markets = markets.where("name ILIKE ?", "%#{params[:name]}%")
    end

    if params[:state] && params[:city] && !params[:name]
      markets = markets.where("state ILIKE ? AND city ILIKE ?", 
                              "%#{params[:state]}%", 
                              "%#{params[:city]}%"
                              )
    end

    if params[:state] && params[:name] && !params[:city]
      markets = markets.where("state ILIKE ? AND name ILIKE ?", 
                              "%#{params[:state]}%", 
                              "%#{params[:name]}%"
                              )
    end

    if params[:state] && params[:city] && params[:name]
      markets = markets.where("state ILIKE ? AND city ILIKE ? AND name ILIKE ?", 
                              "%#{params[:state]}%", 
                              "%#{params[:city]}%", 
                              "%#{params[:name]}%"
                              )
    end

    if params[:city] && !params[:state] && !params[:name]
      render json: { errors: [{ detail: "Cannot send in just city params" }] }, status: 422 and return
    end

    if params[:city] && params[:name] && !params[:state]
      render json: { errors: [{ detail: "Cannot send in just city and name params" }] }, status: 422 and return
    end
    render json: MarketSerializer.new(markets)
  end 

  def nearest_atms
    begin
      market = Market.find(params[:market_id])
      nearby_atms = NearestAtmFacade.nearby_atms(market)

      atms_json = nearby_atms.map do |atm|
        {
          id: nil,
          type: 'atm',
          attributes: {
            name: atm.name,
            address: atm.address,
            lat: atm.lat,
            lon: atm.lon,
            distance: atm.distance
          }
        }
      end

      render json: { data: atms_json }, status: :ok

    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end
end
