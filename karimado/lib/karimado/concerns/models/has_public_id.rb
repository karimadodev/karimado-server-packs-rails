module Karimado
  module Concerns
    module Models
      module HasPublicId
        extend ActiveSupport::Concern

        module ClassMethods
          def has_public_id(attribute = :public_id, length: 32, on: ActiveRecord.generate_secure_token_on)
            define_method("regenerate_#{attribute}") do
              update!(attribute => self.class.generate_unique_public_id(length: length))
            end

            set_callback(on, (on == :initialize) ? :after : :before) do
              if new_record? && !query_attribute(attribute)
                write_attribute(attribute, self.class.generate_unique_public_id(length: length))
              end
            end
          end

          def generate_unique_public_id(length:)
            SecureRandom.base36(length)
          end
        end
      end
    end
  end
end
