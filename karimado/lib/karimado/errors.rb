module Karimado
  module Errors
    Error = Class.new(StandardError)

    InvalidToken = Class.new(Error)
    TokenExpired = Class.new(InvalidToken)
    TokenRevoked = Class.new(InvalidToken)
  end
end
