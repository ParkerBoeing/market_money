class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, presence: true
  validates :description, presence: true
  validates :contact_name, presence: true
  validates :contact_phone, presence: true
  validate :credit_accepted_is_boolean

  def credit_accepted_is_boolean
    unless [true, false].include?(credit_accepted)
      errors.add(:credit_accepted, "Credit accepted must be true or false.")
    end
  end
end
