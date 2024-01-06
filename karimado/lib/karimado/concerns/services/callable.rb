module Karimado
  module Concerns
    module Services
      module Callable
        extend ActiveSupport::Concern

        module ClassMethods
          def call(...)
            catch(:karimado_done) do
              value = new.call(...)
              @_karimado_result =
                value.is_a?(Result) ? value : success_result(value)
            end
            @_karimado_result
          end
        end

        private

        def success!(value = nil)
          @_karimado_result = success_result(value)
          throw :karimado_done
        end

        def fail!(code_or_message = nil, message = nil)
          @_karimado_result = failure_result(code_or_message, message)
          throw :karimado_done
        end

        def success_result(value)
          Result.new(:ok, nil, value: value)
        end

        def failure_result(code_or_message, message)
          if code_or_message.is_a?(Symbol) || code_or_message.is_a?(Numeric)
            Result.new(code_or_message, message)
          else
            Result.new(:error, message || code_or_message)
          end
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
