module Karimado
  module Concerns
    module Services
      module Callable
        extend ActiveSupport::Concern

        included do |base|
          attr_accessor :_karimado_result

          base.const_set("Error", Class.new(StandardError) do
            attr_reader :result

            def initialize(result)
              @result = result
              super(@result)
            end
          end)
        end

        module ClassMethods
          def call(...)
            new.tap do |instance|
              catch(:_karimado_done) do
                value = instance.call(...)
                instance._karimado_result = value.is_a?(Result) ? value : karimado_success_result(value)
              end
            end._karimado_result
          end

          def call!(...)
            call(...).tap do |result|
              break result if result.success?
              raise const_get("Error").new(result)
            end
          end

          def karimado_success_result(value)
            Result.new(:ok, nil, value: value)
          end

          def karimado_failure_result(code_or_message, message)
            if code_or_message.is_a?(Symbol)
              raise ArgumentError, "invalid failure code: :ok" if code_or_message == :ok
              Result.new(code_or_message, message)
            elsif code_or_message.is_a?(Numeric)
              raise ArgumentError, "invalid failure code: 0" if code_or_message == 0
              Result.new(code_or_message, message)
            else
              Result.new(:error, message || code_or_message)
            end
          end
        end

        private

        def ok!(value = nil)
          @_karimado_result = self.class.karimado_success_result(value)
          throw :_karimado_done
        end

        def error!(code_or_message = nil, message = nil)
          @_karimado_result = self.class.karimado_failure_result(code_or_message, message)
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

        def to_s
          (message || code).to_s
        end
      end
    end
  end
end
