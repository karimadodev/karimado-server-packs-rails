RSpec.describe Karimado::UserAuthentication, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }
    it { expect(FactoryBot.build(:user_authentication)).to validate_uniqueness_of(:uid).scoped_to(:provider) }
  end
end
