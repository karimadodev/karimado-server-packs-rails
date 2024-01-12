RSpec.describe Karimado::Config::Authn do
  describe "#access_token_lifetime" do
    it "is expected to set default value to 2 hours" do
      expect(subject.access_token_lifetime).to eq(2.hours)
    end

    it "is expected to at least 5 minutes" do
      expect { subject.access_token_lifetime = 5.minutes - 1 }.to raise_error(ArgumentError, /at least 5 minutes/)
      expect { subject.access_token_lifetime = 5.minutes }.to_not raise_error
    end

    it "is expected to no more than 24 hours" do
      expect { subject.access_token_lifetime = 24.hours + 1 }.to raise_error(ArgumentError, /no more than 24 hours/)
      expect { subject.access_token_lifetime = 24.hours }.to_not raise_error
    end
  end

  describe "#refresh_token_lifetime" do
    it "is expected to set default value to 24 hours" do
      expect(subject.refresh_token_lifetime).to eq(24.hours)
    end

    it "is expected to at least 60 minutes" do
      expect { subject.refresh_token_lifetime = 60.minutes - 1 }.to raise_error(ArgumentError, /at least 60 minutes/)
      expect { subject.refresh_token_lifetime = 60.minutes }.to_not raise_error
    end

    it "is expected to no more than 12 months" do
      expect { subject.refresh_token_lifetime = 12.months + 1 }.to raise_error(ArgumentError, /no more than 12 months/)
      expect { subject.refresh_token_lifetime = 12.months }.to_not raise_error
    end
  end

  describe "#refresh_token_grace_period" do
    it "is expected to set default value to 30 seconds" do
      expect(subject.refresh_token_grace_period).to eq(30.seconds)
    end

    it "is expected to at least 0 seconds" do
      expect { subject.refresh_token_grace_period = - 1 }.to raise_error(ArgumentError, /at least 0 seconds/)
      expect { subject.refresh_token_grace_period = 0 }.to_not raise_error
    end

    it "is expected to no more than 2 minutes" do
      expect { subject.refresh_token_grace_period = 2.minutes + 1 }.to raise_error(ArgumentError, /no more than 2 minutes/)
      expect { subject.refresh_token_grace_period = 2.minutes }.to_not raise_error
    end
  end
end
