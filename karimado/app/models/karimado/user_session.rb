module Karimado
  class UserSession < ApplicationRecord
    belongs_to :user

    has_secure_token :sid, length: 36
    has_secure_token :access_token, length: 36
  end
end
