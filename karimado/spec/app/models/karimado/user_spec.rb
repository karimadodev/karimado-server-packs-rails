RSpec.describe Karimado::User, type: :model do
  subject { FactoryBot.create(:user) }

  describe "associations" do
    it { is_expected.to have_many(:user_sessions) }
    it { is_expected.to have_many(:user_authentications) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_uniqueness_of(:uid) }
  end
end
