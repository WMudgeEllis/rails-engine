FactoryBot.define do
  factory :item do
    name { Faker::GreekPhilosophers.name }
    description { Faker::GreekPhilosophers.quote }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end
