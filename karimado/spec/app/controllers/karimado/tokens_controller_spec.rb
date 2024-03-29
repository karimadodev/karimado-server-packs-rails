RSpec.describe Karimado::TokensController, type: :controller do
  routes { Karimado::Engine.routes }

  describe "routing", type: :routing do
    it "is expected to have route /auth/token" do
      expect(post: "/karimado/auth/token").to be_routable
    end

    it "is expected to have route /auth/token/refresh" do
      expect(post: "/karimado/auth/token/refresh").to be_routable
    end

    it "is expected to have route /auth/token/revoke" do
      expect(post: "/karimado/auth/token/revoke").to be_routable
    end
  end

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
      expect(response.parsed_body["message"]).to eq("invalid username or password")
    end

    it "is expected to response #failure when password not set" do
      post :create, params: {username: user.uid}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("invalid username or password")
    end

    it "is expected to response #failure when password wrong" do
      post :create, params: {username: user.uid, password: password.next}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("invalid username or password")
    end
  end

  describe "#refresh" do
    let!(:session) { FactoryBot.create(:user_session) }
    let!(:authn_token) { session.authn_token }
    let!(:access_token) { authn_token[:access_token] }
    let!(:refresh_token) { authn_token[:refresh_token] }

    it "is expected to response #success" do
      refresh_token_base = session.refresh_token_base
      access_token_base = session.access_token_base
      post :refresh, params: {token: refresh_token}

      expect(response.status).to eq(200)
      expect(response.parsed_body["code"]).to eq(0)
      expect(response.parsed_body["message"]).to eq("OK")
      expect(response.parsed_body["data"].keys).to contain_exactly(
        "access_token",
        "access_token_expires_in",
        "refresh_token",
        "refresh_token_expires_in"
      )

      session.reload
      expect(session.refresh_token_base).not_to eq(refresh_token_base)
      expect(session.access_token_base).not_to eq(access_token_base)
    end

    it "is expected to response #success when token has been rotated but in a grace period" do
      post :refresh, params: {token: refresh_token}
      expect(response.status).to eq(200)

      session.reload
      refresh_token_base = session.refresh_token_base
      access_token_base = session.access_token_base
      post :refresh, params: {token: refresh_token}

      expect(response.status).to eq(200)
      expect(response.parsed_body["code"]).to eq(0)
      expect(response.parsed_body["message"]).to eq("OK")
      expect(response.parsed_body["data"].keys).to contain_exactly(
        "access_token",
        "access_token_expires_in",
        "refresh_token",
        "refresh_token_expires_in"
      )

      session.reload
      expect(session.refresh_token_base).to eq(refresh_token_base)
      expect(session.access_token_base).to eq(access_token_base)
    end

    it "is expected to response #failure when token expired" do
      Timecop.freeze(Karimado.config.authn.refresh_token_lifetime.from_now + 1)
      post :refresh, params: {token: refresh_token}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("token has expired")
    end

    it "is expected to response #failure when token not set" do
      post :refresh, params: {}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to match(/invalid token: /)
    end

    it "is expected to response #failure when token has been rotated" do
      post :refresh, params: {token: refresh_token}
      expect(response.status).to eq(200)

      Timecop.freeze(Karimado.config.authn.refresh_token_grace_period.from_now + 1)
      post :refresh, params: {token: refresh_token}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("token has been revoked")
    end

    it "is expected to response #failure when token has been revoked" do
      post :revoke, params: {token: access_token}
      expect(response.status).to eq(200)

      post :refresh, params: {token: refresh_token}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("token has been revoked")
    end
  end

  describe "#revoke" do
    let!(:session) { FactoryBot.create(:user_session) }
    let!(:authn_token) { session.authn_token }
    let!(:access_token) { authn_token[:access_token] }
    let!(:refresh_token) { authn_token[:refresh_token] }

    it "is expected to response #success" do
      post :revoke, params: {token: access_token}

      expect(response.status).to eq(200)
      expect(response.parsed_body["code"]).to eq(0)
      expect(response.parsed_body["message"]).to eq("OK")
      expect(response.parsed_body["data"]).to eq({})

      session.reload
      expect(session).to be_discarded
    end

    it "is expected to response #failure when token expired" do
      Timecop.freeze(Karimado.config.authn.refresh_token_lifetime.from_now + 1)
      post :revoke, params: {token: access_token}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("token has expired")
    end

    it "is expected to response #failure when token not set" do
      post :revoke

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to match(/invalid token: /)
    end

    it "is expected to response #failure when token has been rotated" do
      post :refresh, params: {token: refresh_token}
      expect(response.status).to eq(200)

      post :revoke, params: {token: access_token}

      expect(response.status).to eq(400)
      expect(response.parsed_body["code"]).to eq(1)
      expect(response.parsed_body["message"]).to eq("token has been revoked")
    end
  end
end
