require 'rails_helper'

describe "Markets API" do
  describe "index" do
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
  end

  describe "market show" do
    it "sends a market happy path" do
      market = create(:market)

      get "/api/v0/markets/#{market.id}"

      expect(response).to be_successful
      parsed_body = JSON.parse(response.body, symbolize_names: true)
      market = parsed_body[:data]

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

    it "has a market show sad path" do
      get '/api/v0/markets/9999999'

      expect(response).to have_http_status(404)

      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq({"errors"=>[{"detail"=>"Couldn't find Market with 'id'=9999999"}]})
    end
  end

  describe "search features" do
    let!(:market1) { create(:market, name: "MarketOne", state: "NewYork", city: "NYC") }
    let!(:market2) { create(:market, name: "MarketTwo", state: "California", city: "LA") }
    let!(:market3) { create(:market, name: "MarketThree", state: "NewYork", city: "Buffalo") }


    describe "happy paths" do
      it "returns markets that match the state" do
        get "/api/v0/markets/search?state=NewYork"
        expect(response).to have_http_status(200)
        data = JSON.parse(response.body)["data"]
        expect(data.size).to eq(2)
        expect(data.sample["attributes"]["state"]).to eq("NewYork")
      end

      it "returns markets that match the name" do
        get "/api/v0/markets/search?name=MarketOne"
        expect(response).to have_http_status(200)
        data = JSON.parse(response.body)["data"]
        expect(data.size).to eq(1)
        expect(data.sample["attributes"]["name"]).to eq("MarketOne")
      end
    
      it "returns markets that match the state and city" do
        get "/api/v0/markets/search?state=NewYork&city=NYC"
        expect(response).to have_http_status(200)
        data = JSON.parse(response.body)["data"]
        expect(data.size).to eq(1)
        expect(data.sample["attributes"]["state"]).to eq("NewYork")
        expect(data.sample["attributes"]["city"]).to eq("NYC")
      end

      it "returns markets that match the state and name" do
        get "/api/v0/markets/search?state=NewYork&name=MarketThree"
        expect(response).to have_http_status(200)
        data = JSON.parse(response.body)["data"]
        expect(data.size).to eq(1)
        expect(data.sample["attributes"]["state"]).to eq("NewYork")
        expect(data.sample["attributes"]["name"]).to eq("MarketThree")
      end

      it "returns markets that match the state, city and name" do
        get "/api/v0/markets/search?state=NewYork&city=NYC&name=MarketOne"
        expect(response).to have_http_status(200)
        data = JSON.parse(response.body)["data"]
        expect(data.size).to eq(1)
        expect(data.sample["attributes"]["state"]).to eq("NewYork")
        expect(data.sample["attributes"]["city"]).to eq("NYC")
        expect(data.sample["attributes"]["name"]).to eq("MarketOne")
      end
    end

    describe "sad paths" do
      it "returns an error if only city is sent in" do
        get "/api/v0/markets/search?city=NYC"
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["errors"]).to include("detail" => "Cannot send in just city params")
      end

      it "returns an error if only city and name are sent in" do
        get "/api/v0/markets/search?city=NYC&name=MarketOne"
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["errors"]).to include("detail" => "Cannot send in just city and name params")
      end
    end
  end
end