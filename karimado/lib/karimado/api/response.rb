module Karimado
  module API
    class Response
      def initialize(code, message, data: nil)
        @code = Code.new(code)
        @message = message
        @data = data
      end

      def code
        @code.value
      end

      def message
        @message || @code.reason
      end

      def data
        @data || {}
      end

      def to_json
        if code == 0
          {code:, message:, data:}
        else
          {code:, message:}
        end
      end
    end
  end
end
