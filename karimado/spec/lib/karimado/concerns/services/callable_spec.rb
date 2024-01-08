RSpec.describe Karimado::Concerns::Services::Callable, type: :service do
  describe ".call" do
    it "is expected to return last evaluated value" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          1 + 1
        end
      end.call

      expect(r).to be_success
      expect(r.code).to eq(:ok)
      expect(r.message).to be_nil
      expect(r.value).to eq(2)
    end

    it "is expected to return #success! result" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          success!
          "unreachable"
        end
      end.call

      expect(r).to be_success
      expect(r.code).to eq(:ok)
      expect(r.message).to be_nil
      expect(r.value).to be_nil
    end

    it "is expected to return #success! result with value" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          success!(a: 1)
          "unreachable"
        end
      end.call

      expect(r).to be_success
      expect(r.code).to eq(:ok)
      expect(r.message).to be_nil
      expect(r.value).to eq({a: 1})
    end

    it "is expected to return #fail! result" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          fail!
          "unreachable"
        end
      end.call

      expect(r).to be_failure
      expect(r.code).to eq(:error)
      expect(r.message).to be_nil
      expect(r.value).to be_nil
    end

    it "is expected to return #fail! result with code" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          fail! :unauthorized
          "unreachable"
        end
      end.call

      expect(r).to be_failure
      expect(r.code).to eq(:unauthorized)
      expect(r.message).to be_nil
      expect(r.value).to be_nil
    end

    it "is expected to return #fail! result with message" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          fail! "authorization is required"
          "unreachable"
        end
      end.call

      expect(r).to be_failure
      expect(r.code).to eq(:error)
      expect(r.message).to eq("authorization is required")
      expect(r.value).to be_nil
    end

    it "is expected to return #fail! result with code & message" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          fail! :unauthorized, "authorization is required"
          "unreachable"
        end
      end.call

      expect(r).to be_failure
      expect(r.code).to eq(:unauthorized)
      expect(r.message).to eq("authorization is required")
      expect(r.value).to be_nil
    end

    it "is expected to raise error when #fail! with :ok code" do
      klass = Class.new do
        include Karimado::Concerns::Services::Callable

        def call(code)
          fail! code
          "unreachable"
        end
      end

      expect { klass.call(:ok) }.to raise_error(ArgumentError, "invalid failure code: :ok")
      expect { klass.call(0) }.to raise_error(ArgumentError, "invalid failure code: 0")
    end

    it "is expected to raise error when no #call method" do
      klass = Class.new do
        include Karimado::Concerns::Services::Callable
      end

      expect { klass.call! }.to raise_error(NoMethodError)
    end
  end

  describe ".call!" do
    it "is expected to return last evaluated value" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          1 + 1
        end
      end.call!

      expect(r).to be_success
      expect(r.code).to eq(:ok)
      expect(r.message).to be_nil
      expect(r.value).to eq(2)
    end

    it "is expected to return #success! result" do
      r = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          success!
          "unreachable"
        end
      end.call!

      expect(r).to be_success
      expect(r.code).to eq(:ok)
      expect(r.message).to be_nil
      expect(r.value).to be_nil
    end

    it "is expected to raise error when #fail!" do
      klass = Class.new do
        include Karimado::Concerns::Services::Callable

        def call
          fail!
        end
      end

      expect { klass.call! }.to raise_error(klass.const_get("Error"))
    end
  end
end
