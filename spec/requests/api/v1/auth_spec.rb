require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  let(:headers) { {"Content-Type" => "application/json"} }

  describe "POST /api/v1/auth/register" do
    let(:valid_params) do
      {
        user: {
          name: "Test Doe",
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }.to_json
    end

    it "registers a new user and returns token" do
      post "/api/v1/auth/register", params: valid_params, headers: headers
      body = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      expect(body).to have_key("token")
      expect(body["user"]["email"]).to eq("test@example.com")
    end

    it "returns error when email already taken" do
      create(:user, email: "test@example.com")
      post "/api/v1/auth/register", params: valid_params, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)).to have_key("errors")
    end

    it "returns error when password confirmation does not match" do
      params = {user: {name: "Test", email: "test@example.com", password: "password123", password_confirmation: "wrong"}}.to_json
      post "/api/v1/auth/register", params: params, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }

    it "logs in and returns token" do
      post "/api/v1/auth/login",
        params: {user: {email: "test@example.com", password: "password123"}}.to_json,
        headers: headers
      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body).to have_key("token")
    end

    it "returns error when password is wrong" do
      post "/api/v1/auth/login",
        params: {user: {email: "test@example.com", password: "wrongpassword"}}.to_json,
        headers: headers
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to have_key("error")
    end

    it "returns error when email not found" do
      post "/api/v1/auth/login",
        params: {user: {email: "notfound@example.com", password: "password123"}}.to_json,
        headers: headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/auth/logout" do
    let!(:user) { create(:user) }

    it "logs out and rotates token" do
      old_token = user.token

      delete "/api/v1/auth/logout", headers: headers.merge("Authorization" => "Bearer #{old_token}")

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Logout successful")
      expect(user.reload.token).not_to eq(old_token)
    end

    it "returns 401 when unauthenticated" do
      delete "/api/v1/auth/logout", headers: headers

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
