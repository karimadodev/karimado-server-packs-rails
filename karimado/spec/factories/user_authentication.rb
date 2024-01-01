FactoryBot.define do
  factory :user_authentication, class: Karimado::UserAuthentication do
    provider { "identifier" }
    uid { SecureRandom.uuid }

    user
  end
end
