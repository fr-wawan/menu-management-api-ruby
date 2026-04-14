FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    address { Faker::Address.full_address }
    phone { Faker::PhoneNumber.phone_number }
    opening_hours { "08:00 - 22:00" }
  end
end
