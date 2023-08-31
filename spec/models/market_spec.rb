require 'rails_helper'

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "instance methods" do
    it "can #vendor_count" do
      market = create(:market)

      create_list(:vendor, 3, markets: [market])                            

      expect(market.vendor_count).to eq(3)
    end
  end
end
