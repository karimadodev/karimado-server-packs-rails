RSpec.describe Karimado::User, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:user_sessions) }
    it { is_expected.to have_many(:user_authentications) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
