RSpec.describe Karimado::Configuration do
  describe "defaults" do
    it "is expected to set authn.access_token_expires_in" do expect(subject.authn.access_token_expires_in).to eq(1.hour) end
    it "is expected to set authn.refresh_token_expires_in" do expect(subject.authn.refresh_token_expires_in).to eq(1.day) end
  end
end
