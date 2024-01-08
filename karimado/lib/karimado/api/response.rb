module Karimado
  module API
    class Response
      def initialize(code, message = nil, data: nil)
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

      def http_status
        case code
        when 0 then 200
        when 1 then 400
        when 1_400_000..1_499_999 then code.div(1_000) - 1_000
        when 1_500_000..1_599_999 then code.div(1_000) - 1_000
        else raise ArgumentError
        end
      end

      def to_json(...)
        if code == 0
          {code:, message:, data:}
        else
          {code:, message:}
        end
      end
    end
  end
end
