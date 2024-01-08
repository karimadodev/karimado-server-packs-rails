RSpec.describe Karimado::API::Response do
  describe "response :ok" do
    subject { described_class.new(:ok) }
    it "is expected to have code 0" do expect(subject.code).to eq(0) end
    it "is expected to have message \"OK\"" do expect(subject.message).to eq("OK") end
    it "is expected to have data \"{}\"" do expect(subject.data).to eq({}) end
    it "is expected to have http status code 200" do expect(subject.http_status).to eq(200) end
  end

  describe "response :error" do
    subject { described_class.new(:error) }
    it "is expected to have code 1" do expect(subject.code).to eq(1) end
    it "is expected to have message \"ERROR\"" do expect(subject.message).to eq("ERROR") end
    it "is expected to have http status code 200" do expect(subject.http_status).to eq(400) end
  end

  describe ".new" do
    it "is expected to raise error when code not found" do
      expect { described_class.new(nil) }.to raise_error(ArgumentError)
      expect { described_class.new(123456) }.to raise_error(ArgumentError)
      expect { described_class.new(:error_unknown) }.to raise_error(ArgumentError)
    end
  end

  describe "#message" do
    it "is expected to use code reason when not set" do
      expect(described_class.new(:unauthorized).message).to eq("Unauthorized")
    end

    it "is expected to use message" do
      expect(described_class.new(:unauthorized, "authorization is required").message).to eq("authorization is required")
    end
  end

  describe "#to_json" do
    it "is expected to have fields :code, :message, :data when response :ok" do
      expect(described_class.new(:ok).to_json).to eq({code: 0, message: "OK", data: {}})
    end

    it "is expected to have fields :code, :message when response :error" do
      expect(described_class.new(:error).to_json).to eq({code: 1, message: "ERROR"})
    end
  end
end
