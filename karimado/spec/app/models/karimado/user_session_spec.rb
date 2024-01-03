RSpec.describe Karimado::UserSession, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to have_secure_token(:access_token_base).ignoring_check_for_db_index }
    it { is_expected.to have_secure_token(:refresh_token_base).ignoring_check_for_db_index }
  end
end
