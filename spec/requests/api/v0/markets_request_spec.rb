require 'rails_helper'

describe "Markets API" do
  it "sends a list of markets" do
    create_list(:market, 10)

    get '/api/v0/markets'

    expect(response).to be_successful
    expect(JSON.parse(response.body).size).to eq(10)
  end
end