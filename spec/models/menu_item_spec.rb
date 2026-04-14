require "rails_helper"

RSpec.describe MenuItem, type: :model do
  describe "associations" do
    it { should belong_to(:restaurant) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  describe "enums" do
    it {
      should define_enum_for(:category)
        .with_values(appetizer: "appetizer", main: "main", dessert: "dessert", drink: "drink")
        .backed_by_column_of_type(:string)
    }
  end
end
