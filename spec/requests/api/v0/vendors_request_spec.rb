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

  describe "create vendor" do
    it "happy path" do
      vendor_params = ({
        name: 'Apple',
        description: 'Take over the world',
        contact_name: 'Stevejobs@gmail.com',
        contact_phone: '999-999-9999',
        credit_accepted: true
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last

      expect(response).to be_successful
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end

    it "sad path for booleans" do
      vendor_params = ({
        name: 'Apple',
        description: 'Take over the world',
        contact_name: 'Stevejobs@gmail.com',
        contact_phone: '999-999-9999',
        credit_accepted: "bananas"
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last
      expect(response).to have_http_status(400)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq({"errors"=>[{"detail"=>"Credit accepted must be a boolean"}]})
    end

    it "sad path for other validations" do
      vendor_params = ({
        description: 'Take over the world',
        contact_name: 'Stevejobs@gmail.com',
        contact_phone: '999-999-9999',
        credit_accepted: true
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last
      expect(response).to have_http_status(400)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq({"errors"=>[{"detail"=>{"name"=>["can't be blank"]}}]})
    end
  end

  describe "vendor update" do
    it "happy path" do
      id = create(:vendor).id
      previous_name = Vendor.last.name
      vendor_params = { name: "X" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
      vendor = Vendor.find_by(id: id)

      expect(response).to be_successful
      expect(vendor.name).to_not eq(previous_name)
      expect(vendor.name).to eq("X")
    end

    it "sad path for blank fields" do
      id = create(:vendor).id
      previous_name = Vendor.last.name
      vendor_params = { name: "" }
      headers = {"CONTENT_TYPE" => "application/json"}
      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})

      expect(response).to have_http_status(400)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq({"errors"=>[{"detail"=>{"name"=>["can't be blank"]}}]})
    end

    it "sad path for unfound vendor" do
      vendor_params = { name: "X" }
      patch "/api/v0/vendors/9999999", headers: headers, params: JSON.generate({vendor: vendor_params})
      expect(response).to have_http_status(404)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq({"errors"=>[{"detail"=>"Couldn't find Vendor with 'id'=9999999"}]})
    end
  end

  describe "destroy vendor" do
    it "happy path" do
      vendor = create(:vendor)
      expect(Vendor.last.name).to eq(vendor.name)
      vendor_count = Vendor.count
    
      delete "/api/v0/vendors/#{vendor.id}"
    
      expect(response).to be_successful
      expect(Vendor.count).to eq(vendor_count - 1)
      expect(Vendor.last.name).to_not eq(vendor.name)
      expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "sad path" do
      delete "/api/v0/vendors/9999999"
      expect(response).to have_http_status(404)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eq({"errors"=>[{"detail"=>"Couldn't find Vendor with 'id'=9999999"}]})
    end
  end
end