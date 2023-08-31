require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe "custom validations" do
    it 'is valid with credit_accepted as true' do
      vendor = FactoryBot.build(:vendor, credit_accepted: true)
      expect(vendor).to be_valid
    end

    it 'is valid with credit_accepted as false' do
      vendor = FactoryBot.build(:vendor, credit_accepted: false)
      expect(vendor).to be_valid
    end

    it 'is not valid with credit_accepted as nil' do
      vendor = FactoryBot.build(:vendor, credit_accepted: nil)
      expect(vendor).to_not be_valid
      expect(vendor.errors[:credit_accepted]).to include("Credit accepted must be true or false.")
    end

    it 'is not valid with credit_accepted as something other than true or false' do
      vendor = FactoryBot.build(:vendor, credit_accepted: 'invalid_value')
      expect(vendor).to_not be_valid
      expect(vendor.errors[:credit_accepted]).to include("Credit accepted must be true or false.")
    end
  end
end
