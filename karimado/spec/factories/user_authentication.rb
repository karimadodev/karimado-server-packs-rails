FactoryBot.define do
  factory :user_authentication, class: Karimado::UserAuthentication do
    provider { "identifier" }
    uid { SecureRandom.alphanumeric(8) }

    user
  end
end
