Karimado::Engine.routes.draw do
  resource :token, only: [:create] do
    post "refresh"
    post "revoke"
  end
end
