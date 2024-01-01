RSpec.describe Karimado::UserSession, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to have_secure_token(:sid) }
    it { is_expected.to have_secure_token(:access_token) }
  end
end
