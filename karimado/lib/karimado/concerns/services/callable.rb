module Karimado
  module Concerns
    module Services
      module Callable
        extend ActiveSupport::Concern

        included do
          attr_accessor :_karimado_result
        end

        module ClassMethods
          def call(...)
            new.tap do |instance|
              catch(:_karimado_done) do
                value = instance.call(...)
                instance._karimado_result = value.is_a?(Result) ? value : success_result(value)
              end
            end._karimado_result
          end

          def success_result(value)
            Result.new(:ok, nil, value: value)
          end

          def failure_result(code_or_message, message)
            if code_or_message.is_a?(Symbol)
              raise ArgumentError if code_or_message == :ok
              Result.new(code_or_message, message)
            elsif code_or_message.is_a?(Numeric)
              raise ArgumentError if code_or_message == 0
              Result.new(code_or_message, message)
            else
              Result.new(:error, message || code_or_message)
            end
          end
        end

        private

        def success!(value = nil)
          @_karimado_result = self.class.success_result(value)
          throw :_karimado_done
        end

        def fail!(code_or_message = nil, message = nil)
          @_karimado_result = self.class.failure_result(code_or_message, message)
          throw :_karimado_done
        end
      end

      class Result
        attr_reader :code, :message, :value

        def initialize(code, message, value: nil)
          @code = code
          @message = message
          @value = value
        end

        def success?
          @code == :ok || @code == 0
        end

        def failure?
          !success?
        end
      end
    end
  end
end
