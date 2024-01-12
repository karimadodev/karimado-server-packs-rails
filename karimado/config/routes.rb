Karimado::Engine.routes.draw do
  scope :auth do
    resource :token, only: [:create] do
      post "refresh"
      post "revoke"
    end
  end
end
