RSpec.describe Karimado::UserSession, type: :model do
  subject { FactoryBot.create(:user_session) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to have_secure_token(:access_token_base).ignoring_check_for_db_index }
    it { is_expected.to have_secure_token(:refresh_token_base).ignoring_check_for_db_index }
  end

  describe "#authn_token" do
    it "is expected to have :access_token, :refresh_token, etc." do
      authn_token = subject.authn_token
      expect(authn_token).to have_key(:access_token)
      expect(authn_token).to have_key(:refresh_token)
    end

    it "is expected to have :expires_in" do
      authn_token = subject.authn_token
      expect(authn_token[:access_token_expires_in]).to eq(2.hours)
      expect(authn_token[:refresh_token_expires_in]).to eq(24.hours)

      Timecop.freeze(24.hours.from_now + 1)
      expect {
        Karimado::UserSessionAccessToken.decode(authn_token[:access_token])
      }.to raise_error(Karimado::Errors::TokenExpired, "token has expired")
      expect {
        Karimado::UserSessionRefreshToken.decode(authn_token[:refresh_token])
      }.to raise_error(Karimado::Errors::TokenExpired, "token has expired")
    end
  end

  describe "#valid_previous_refresh_token" do
    it "is expected to be truthy" do
      authn_token = subject.authn_token
      token = Karimado::UserSessionRefreshToken.decode(authn_token[:refresh_token])
      subject.regenerate_refresh_token_base

      expect(subject.valid_previous_refresh_token?(token)).to be_truthy
    end

    it "is expected to be falsey after the grace period" do
      authn_token = subject.authn_token
      token = Karimado::UserSessionRefreshToken.decode(authn_token[:refresh_token])
      subject.regenerate_refresh_token_base

      Timecop.freeze(Karimado.config.authn.refresh_token_grace_period.from_now + 1)
      expect(subject.valid_previous_refresh_token?(token)).to be_falsey
    end
  end
end
