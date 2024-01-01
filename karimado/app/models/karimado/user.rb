module Karimado
  class User < ApplicationRecord
    has_many :user_authentications
    has_many :user_sessions

    validates :name, presence: true
  end
end
