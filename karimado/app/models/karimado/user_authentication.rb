module Karimado
  class UserAuthentication < ApplicationRecord
    belongs_to :user

    validates :provider, presence: true
    validates :provider, uniqueness: {scope: :user_id}

    validates :uid, presence: true
    validates :uid, uniqueness: {scope: :provider}
  end
end
