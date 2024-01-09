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
      expect(authn_token[:access_token_expires_in]).to eq(1.hour)
      expect(authn_token[:refresh_token_expires_in]).to eq(1.day)

      Timecop.freeze((1.day + 1.hour).from_now)
      expect {
        Karimado::UserSessionAccessToken.decode(authn_token[:access_token])
      }.to raise_error(Karimado::Errors::TokenExpired, "token has expired")
      expect {
        Karimado::UserSessionRefreshToken.decode(authn_token[:refresh_token])
      }.to raise_error(Karimado::Errors::TokenExpired, "token has expired")
    end
  end
end
