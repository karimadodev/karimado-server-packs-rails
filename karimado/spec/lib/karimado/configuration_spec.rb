RSpec.describe Karimado::Configuration do
  describe "defaults" do
    it { expect(subject.authn.access_token_expires_in).to eq(1.hour) }
    it { expect(subject.authn.refresh_token_expires_in).to eq(1.day) }
  end
end
