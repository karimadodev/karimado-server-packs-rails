RSpec.describe Karimado::UserAuthentication, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    subject { FactoryBot.build(:user_authentication) }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_uniqueness_of(:provider).scoped_to(:user_id) }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
  end
end
