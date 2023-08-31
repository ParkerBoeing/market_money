require 'rails_helper'

describe "Markets API" do
  it "sends a list of markets" do
    create_list(:market, 10)

    get '/api/v0/markets'

    expect(response).to be_successful
    parsed_body = JSON.parse(response.body, symbolize_names: true)
    markets = parsed_body[:data]
    expect(markets.size).to eq(10)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_a(String)

      market = market[:attributes]

      expect(market).to have_key(:name)
      expect(market[:name]).to be_a(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:county)
      expect(market[:county]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_a(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_a(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_a(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_a(String)

      expect(market).to have_key(:vendor_count)
      expect(market[:vendor_count]).to be_an(Integer)
    end
  end

  it "sends a market" do
    
  end
end