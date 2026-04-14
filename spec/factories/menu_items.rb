FactoryBot.define do
  factory :menu_item do
     name { "MyString" }
     description { "MyText" }
     price { "9.99" }
     category { "MyString" }
    is_available { false }
     restaurant { nil }
  end
end
