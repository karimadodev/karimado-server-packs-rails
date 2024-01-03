module Karimado
  class User < ApplicationRecord
    has_many :user_authentications
    has_many :user_sessions

    validates :uid, presence: true
    validates :uid, uniqueness: true
  end
end
