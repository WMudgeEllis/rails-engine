FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Alphanumeric.alpha(number: 10) }
    credit_card_expiration_date { Faker::Alphanumeric.alpha(number: 4) }
    result { 'success' }
  end
end
