FactoryBot.define do
  factory :menu_item do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Number.decimal(l_digits: 2) }
    category { MenuItem.categories.keys.sample }
    is_available { true }
    association :restaurant
  end
end
