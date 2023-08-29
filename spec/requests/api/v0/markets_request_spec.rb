require 'rails_helper'

describe "Markets API" do
  it "sends a list of markets" do
    create_list(:book, 3)

    get '/api/v1/books'

    expect(response).to be_successful
  end
end