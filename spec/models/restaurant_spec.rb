require "rails_helper"

RSpec.describe Restaurant, type: :model do
  describe "associations" do
    it { should have_many(:menu_items).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
  end

  describe ".search" do
    it "returns all when search is blank" do
      create_list(:restaurant, 2)

      expect(described_class.search(nil).count).to eq(2)
    end

    it "filters by name" do
      create(:restaurant, name: "Pizza Palace")
      create(:restaurant, name: "Burger Barn")

      results = described_class.search("Pizza")

      expect(results.count).to eq(1)
      expect(results.first.name).to eq("Pizza Palace")
    end
  end
end
