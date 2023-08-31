require "rails_helper"

RSpec.describe "MarketVendors API", type: :request do
  describe "market vendors" do
    before :each do
      @market = create(:market)
      @vendor = create(:vendor)
    end

    describe "market vendors create" do
      it "happy path" do
        post "/api/v0/market_vendors", params: { market_id: @market.id, vendor_id: @vendor.id }

        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["message"]).to eq("MarketVendor created successfully.")
      end

      it "sad path when invalid vendor id or market id is passed in" do
        post "/api/v0/market_vendors", params: { market_id: 99999999, vendor_id: @vendor.id }

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Couldn't find Market with 'id'=99999999"}]})
      end

      it "returns 422 status" do
        create(:market_vendor, market: @market, vendor: @vendor)
        post "/api/v0/market_vendors", params: { market_id: @market.id, vendor_id: @vendor.id }

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Validation failed: Market vendor association between market with market_id=#{@market.id} and vendor_id=#{@vendor.id} already exists"}]})
      end
    end

    describe "market vendors destroy" do
      it "happy path" do
        post "/api/v0/market_vendors", params: { market_id: @market.id, vendor_id: @vendor.id }

        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["message"]).to eq("MarketVendor created successfully.")
      end

      it "sad path when invalid vendor id or market id is passed in" do
        post "/api/v0/market_vendors", params: { market_id: 99999999, vendor_id: @vendor.id }

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Couldn't find Market with 'id'=99999999"}]})
      end

      it "returns 422 status" do
        create(:market_vendor, market: @market, vendor: @vendor)
        post "/api/v0/market_vendors", params: { market_id: @market.id, vendor_id: @vendor.id }

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Validation failed: Market vendor association between market with market_id=#{@market.id} and vendor_id=#{@vendor.id} already exists"}]})
      end
    end
  end
end
