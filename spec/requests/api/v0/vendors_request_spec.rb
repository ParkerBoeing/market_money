require 'rails_helper'

describe "Markets API" do
  before :each do
    @market = create(:market)

    create_list(:vendor, 3, markets: [@market]) 
  end

  describe "market vendors" do
    it "happy path" do
      get "/api/v0/markets/#{@market.id}/vendors"

      expect(response).to be_successful
      parsed_body = JSON.parse(response.body, symbolize_names: true)
      vendors = parsed_body[:data]
      expect(vendors.size).to eq(3)

      vendors.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)

        vendor = vendor[:attributes]

        expect(vendor).to have_key(:name)
        expect(vendor[:name]).to be_a(String)

        expect(vendor).to have_key(:description)
        expect(vendor[:description]).to be_a(String)

        expect(vendor).to have_key(:contact_name)
        expect(vendor[:contact_name]).to be_a(String)

        expect(vendor).to have_key(:contact_phone)
        expect(vendor[:contact_phone]).to be_a(String)

        expect(vendor).to have_key(:credit_accepted)
        expect([true, false]).to include(vendor[:credit_accepted])
      end
    end

    it "has a sad path" do
      get '/api/v0/markets/9999999/vendors'

      expect(response).to have_http_status(404)

      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq({"errors"=>[{"detail"=>"Couldn't find Market with 'id'=9999999"}]})
    end
  end

  describe "gets a vendor" do
    it "happy path" do
      vendor_id = @market.vendors.sample.id
      get "/api/v0/vendors/#{vendor_id}"

      expect(response).to be_successful
      parsed_body = JSON.parse(response.body, symbolize_names: true)
      vendor = parsed_body[:data]

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)

      vendor = vendor[:attributes]

      expect(vendor).to have_key(:name)
      expect(vendor[:name]).to be_a(String)

      expect(vendor).to have_key(:description)
      expect(vendor[:description]).to be_a(String)

      expect(vendor).to have_key(:contact_name)
      expect(vendor[:contact_name]).to be_a(String)

      expect(vendor).to have_key(:contact_phone)
      expect(vendor[:contact_phone]).to be_a(String)

      expect(vendor).to have_key(:credit_accepted)
      expect([true, false]).to include(vendor[:credit_accepted])
    end

    it "sad path" do
      get '/api/v0/vendors/9999999'

      expect(response).to have_http_status(404)

      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq({"errors"=>[{"detail"=>"Couldn't find Vendor with 'id'=9999999"}]})
    end
  end
end