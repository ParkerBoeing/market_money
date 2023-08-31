require 'rails_helper'

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "instance methods" do
    it "can #vendor_count" do
      market = Market.create!(name: "Lob",
                              street: "Dob",
                              city: "Job",
                              county: "Hob",
                              state: "Nod",
                              zip: "Xob",
                              lat: "lat",
                              lon: "lon"
                              )

      vendor_1 = market.vendors.create!(name: "Shwoop",
                                        description: "Doop",
                                        contact_name: "Boop",
                                        contact_phone: "loop",
                                        credit_accepted: true
                                        )

      vendor_2 = market.vendors.create!(name: "Shwoop",
                                        description: "Doop",
                                        contact_name: "Boop",
                                        contact_phone: "loop",
                                        credit_accepted: true
                                        )

      vendor_3 = market.vendors.create!(name: "Shwoop",
                                        description: "Doop",
                                        contact_name: "Boop",
                                        contact_phone: "loop",
                                        credit_accepted: true
                                        )                                  

      expect(market.vendor_count).to eq(3)
    end
  end
end
