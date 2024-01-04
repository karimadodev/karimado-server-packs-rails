Karimado::Engine.routes.draw do
  namespace :authn do
    resource :token, only: [:create] do
      post "refresh"
      post "revoke"
    end
  end
end
