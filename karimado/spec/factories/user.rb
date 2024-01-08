FactoryBot.define do
  factory :user, class: Karimado::User do
    uid { SecureRandom.alphanumeric(8) }
    password { SecureRandom.base58 }
  end
end
