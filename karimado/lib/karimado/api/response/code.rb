module Karimado
  module API
    class Response
      class Code
        attr_reader :value

        class << self
          private def symbolize(str)
            str.to_s.downcase.gsub(/\s+/, "_").to_sym
          end
        end

        SYMBOLS = REASONS.transform_values { |v| symbolize(v) }.freeze
        SYMBOL_CODES = SYMBOLS.to_h { |k, v| [v, k] }.freeze

        def initialize(value)
          @value = value.is_a?(Symbol) ? SYMBOL_CODES[value] : value
          raise ArgumentError unless SYMBOLS.key?(@value)
        end

        def name
          SYMBOLS[value]
        end

        def reason
          REASONS[value]
        end
      end
    end
  end
end
