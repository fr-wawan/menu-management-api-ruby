require "rails_helper"

RSpec.describe "Api::V1::Restaurants", type: :request do
  let(:user) { create(:user) }
  let(:headers) { {"Authorization" => "Bearer #{user.token}"} }

  describe "GET /api/v1/restaurants" do
    before { create_list(:restaurant, 3) }

    it "returns all restaurants" do
      get "/api/v1/restaurants"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].size).to eq(3)
    end

    it "returns pagination meta" do
      get "/api/v1/restaurants"
      meta = JSON.parse(response.body)["meta"]
      expect(meta).to include("current_page", "total_pages", "total_count")
    end
  end

  describe "GET /api/v1/restaurants/:id" do
    let(:restaurant) { create(:restaurant) }
    before { create_list(:menu_item, 3, restaurant: restaurant) }

    it "returns restaurant with menu items" do
      get "/api/v1/restaurants/#{restaurant.id}"
      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body["menu_items"].size).to eq(3)
    end

    it "returns 404 for non-existent restaurant" do
      get "/api/v1/restaurants/9999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/restaurants" do
    context "when authenticated" do
      it "creates a restaurant" do
        post "/api/v1/restaurants",
          params: {restaurant: {name: "Test Resto", address: "Test Address"}}.to_json,
          headers: headers.merge("Content-Type" => "application/json")
        expect(response).to have_http_status(:created)
      end

      it "returns error when name is missing" do
        post "/api/v1/restaurants",
          params: {restaurant: {address: "Test Address"}}.to_json,
          headers: headers.merge("Content-Type" => "application/json")
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "when unauthenticated" do
      it "returns 401" do
        post "/api/v1/restaurants",
          params: {restaurant: {name: "Test Resto", address: "Test Address"}}.to_json,
          headers: {"Content-Type" => "application/json"}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /api/v1/restaurants/:id" do
    let(:restaurant) { create(:restaurant) }

    it "updates a restaurant" do
      put "/api/v1/restaurants/#{restaurant.id}",
        params: {restaurant: {name: "Updated Name"}}.to_json,
        headers: headers.merge("Content-Type" => "application/json")
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Updated Name")
    end
  end

  describe "DELETE /api/v1/restaurants/:id" do
    let(:restaurant) { create(:restaurant) }

    it "deletes a restaurant" do
      delete "/api/v1/restaurants/#{restaurant.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
