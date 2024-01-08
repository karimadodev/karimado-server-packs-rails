RSpec.describe Karimado::TokensController, type: :controller do
  routes { Karimado::Engine.routes }

  describe "#create" do
    let(:password) { SecureRandom.base58 }
    let(:user) { FactoryBot.create(:user, password:) }

    it "is expected to response #success" do
      post :create, params: {username: user.uid, password:}

      expect(response.status).to eq(200)
      expect(response.parsed_body["code"]).to eq(0)
      expect(response.parsed_body["message"]).to eq("OK")
      expect(response.parsed_body["data"].keys).to contain_exactly(
        "access_token",
        "access_token_expires_in",
        "refresh_token",
        "refresh_token_expires_in"
      )
    end

    it "is expected to response #failure when user not found" do
      post :create, params: {username: user.uid.next, password:}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("Invalid username or password")
    end

    it "is expected to response #failure when password not set" do
      post :create, params: {username: user.uid}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("Invalid username or password")
    end

    it "is expected to response #failure when password wrong" do
      post :create, params: {username: user.uid, password: password.next}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("Invalid username or password")
    end
  end
end
