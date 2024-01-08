module Karimado
  module API
    class Response
      class Code
        REASONS = {
          # 200 OK
          0 => "OK",

          # 400 Bad Request
          1 => "ERROR",

          # 401 Unauthorized
          1_401_000 => "Unauthorized",

          # 403 Forbidden
          1_403_000 => "Forbidden",

          # 500 Internal Server Error
          1_500_000 => "Internal Server Error"
        }.each_value(&:freeze).freeze
      end
    end
  end
end
