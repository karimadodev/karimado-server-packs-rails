module Karimado
  module API
    class Response
      class Code
        REASONS = {
          0 => "OK",
          1 => "ERROR",

          10401 => "Unauthorized"
        }.each_value(&:freeze).freeze
      end
    end
  end
end
