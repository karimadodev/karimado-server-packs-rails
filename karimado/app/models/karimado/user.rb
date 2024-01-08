module Karimado
  class User < ApplicationRecord
    include Karimado::Concerns::Models::HasPublicId

    has_many :user_authentications
    has_many :user_sessions

    has_public_id :public_id
    has_secure_password :password

    validates :uid, presence: true
    validates :uid, uniqueness: true
  end
end
