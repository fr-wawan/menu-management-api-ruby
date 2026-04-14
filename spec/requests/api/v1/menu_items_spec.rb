require "rails_helper"

RSpec.describe "Api::V1::MenuItems", type: :request do
  let(:user) { create(:user) }
  let(:restaurant) { create(:restaurant) }
  let(:headers) { {"Authorization" => "Bearer #{user.token}", "Content-Type" => "application/json"} }

  describe "GET /api/v1/restaurants/:restaurant_id/menu_items" do
    before { create_list(:menu_item, 3, restaurant: restaurant) }

    it "returns all menu items" do
      get "/api/v1/restaurants/#{restaurant.id}/menu_items"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].size).to eq(3)
    end

    it "filters by category" do
      create(:menu_item, restaurant: restaurant, category: "drink")
      get "/api/v1/restaurants/#{restaurant.id}/menu_items?category=drink"
      body = JSON.parse(response.body)
      expect(body["data"].all? { |item| item["category"] == "drink" }).to be true
    end

    it "searches by name" do
      create(:menu_item, restaurant: restaurant, name: "Special Burger")
      get "/api/v1/restaurants/#{restaurant.id}/menu_items?search=Special"
      expect(JSON.parse(response.body)["data"].first["name"]).to eq("Special Burger")
    end
  end

  describe "POST /api/v1/restaurants/:restaurant_id/menu_items" do
    let(:valid_params) do
      {menu_item: {name: "Burger", price: 50000, category: "main", is_available: true}}.to_json
    end

    it "creates a menu item" do
      post "/api/v1/restaurants/#{restaurant.id}/menu_items",
        params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
    end

    it "returns error when unauthenticated" do
      post "/api/v1/restaurants/#{restaurant.id}/menu_items",
        params: valid_params, headers: {"Content-Type" => "application/json"}
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PUT /api/v1/menu_items/:id" do
    let(:menu_item) { create(:menu_item, restaurant: restaurant) }

    it "updates a menu item" do
      put "/api/v1/menu_items/#{menu_item.id}",
        params: {menu_item: {price: 99000}}.to_json,
        headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["price"].to_f).to eq(99000.0)
    end
  end

  describe "DELETE /api/v1/menu_items/:id" do
    let(:menu_item) { create(:menu_item, restaurant: restaurant) }

    it "deletes a menu item" do
      delete "/api/v1/menu_items/#{menu_item.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "scopes" do
    let(:restaurant) { create(:restaurant) }

    before do
      create(:menu_item, restaurant: restaurant, category: "main", name: "Burger")
      create(:menu_item, restaurant: restaurant, category: "drink", name: "Cola")
    end

    it "filters by category" do
      expect(MenuItem.by_category("main").count).to eq(1)
    end

    it "searches by name" do
      expect(MenuItem.by_name("Burger").count).to eq(1)
    end

    it "returns all when category is blank" do
      expect(MenuItem.by_category(nil).count).to eq(2)
    end
  end
end
