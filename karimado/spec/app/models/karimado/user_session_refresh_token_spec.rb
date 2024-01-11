RSpec.describe Karimado::UserSessionRefreshToken, type: :model do
  let(:session) { FactoryBot.create(:user_session) }

  describe "attributes" do
    it "is expected to have :sub, :iat, :exp, etc." do
      now = Time.now
      expires_in = 2.hour
      Timecop.freeze(now)

      token = described_class.encode(session, expires_in:)
      expect(token).to be_a(String)

      token = described_class.decode(token)
      expect(token.sub).to eq(session.user.public_id)
      expect(token.iat).to eq(now.to_i)
      expect(token.exp).to eq(now.to_i + expires_in.to_i)
      expect(token.grant_type).to eq("refresh_token")
      expect(token.refresh_token).to eq(session.refresh_token_base)
      expect(token.user).to eq(session.user)
      expect(token.session).to eq(session)
    end
  end

  describe ".decode" do
    it "is expected to raise error when expired" do
      token = session.authn_token[:refresh_token]

      Timecop.freeze(Karimado.config.authn.refresh_token_lifetime.from_now + 1)
      expect { described_class.decode(token) }.to raise_error(Karimado::Errors::TokenExpired, "token has expired")
    end

    it "is expected to raise error when decode access token" do
      token = session.authn_token[:access_token]
      expect { described_class.decode(token) }.to raise_error(Karimado::Errors::InvalidToken, "invalid token: wrong grant type")
    end
  end
end
