RSpec.describe Karimado::API::Response::Code do
  [
    [:ok, 0],
    [:error, 1],
    [:unauthorized, 1_401_000],
    [:forbidden, 1_403_000],
    [:internal_server_error, 1_500_000]
  ].each do |(name, value)|
    it "is expected to have code :#{name}" do
      code = described_class.new(name)
      expect(code.name).to eq(name)
      expect(code.value).to eq(value)

      code = described_class.new(value)
      expect(code.name).to eq(name)
      expect(code.value).to eq(value)
    end
  end

  describe "code :ok" do
    subject { described_class.new(:ok) }
    it "is expected to have name :ok" do expect(subject.name).to eq(:ok) end
    it "is expected to have value 0" do expect(subject.value).to eq(0) end
    it "is expected to have reason \"OK\"" do expect(subject.reason).to eq("OK") end
  end

  describe "code :error" do
    subject { described_class.new(:error) }
    it "is expected to have name :error" do expect(subject.name).to eq(:error) end
    it "is expected to have value 1" do expect(subject.value).to eq(1) end
    it "is expected to have reason \"ERROR\"" do expect(subject.reason).to eq("ERROR") end
  end

  describe ".new" do
    it "is expected to raise error when code not found" do
      expect { described_class.new(nil) }.to raise_error(ArgumentError, "invalid code: nil")
      expect { described_class.new(123456) }.to raise_error(ArgumentError, "invalid code: 123456")
      expect { described_class.new(:error_unknown) }.to raise_error(ArgumentError, "invalid code: :error_unknown")
    end
  end
end
