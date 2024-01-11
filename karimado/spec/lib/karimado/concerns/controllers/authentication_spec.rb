RSpec.describe Karimado::Concerns::Controllers::Authentication, type: :controller do
  let(:session) { FactoryBot.create(:user_session) }
  let(:authn_token) { session.authn_token }

  controller(ActionController::API) do
    include Karimado::Concerns::Controllers::Authentication

    skip_before_action :karimado_authenticate!, only: [:anonymous]

    def anonymous
      head :ok
    end

    def authenticated
      head :ok
    end
  end

  before do
    routes.draw do
      get "/anonymous/anonymous"
      get "/anonymous/authenticated"
    end
  end

  describe "#karimado_authenticate!" do
    it "is expected to response 200 when skip before action" do
      get :anonymous

      expect(response.status).to eq(200)
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 200 when token set" do
      token = authn_token[:access_token]
      request.headers["Authorization"] = "Bearer #{token}"
      get :authenticated

      expect(response.status).to eq(200)
      expect(controller.__send__(:karimado_access_token)).to be_a(Karimado::UserSessionAccessToken)
    end

    it "is expected to response 401 when token not set" do
      get :authenticated

      expect(response.status).to eq(401)
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 401 when token format invalid" do
      request.headers["Authorization"] = "Bearer abcdef"
      get :authenticated

      expect(response.status).to eq(401)
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 401 when token expired" do
      token = authn_token[:access_token]
      Timecop.freeze(Karimado.config.authn.access_token_lifetime.from_now + 1)

      request.headers["Authorization"] = "Bearer #{token}"
      get :authenticated

      expect(response.status).to eq(401)
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 401 when token rotated" do
      token = authn_token[:access_token]
      result = Karimado::Authn::Token::RefreshService.call(refresh_token: authn_token[:refresh_token])
      expect(result).to be_success

      request.headers["Authorization"] = "Bearer #{token}"
      get :authenticated

      expect(response.status).to eq(401)
      # expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 401 when token revoked" do
      token = authn_token[:access_token]
      result = Karimado::Authn::Token::RevokeService.call(refresh_token: authn_token[:refresh_token])
      expect(result).to be_success

      request.headers["Authorization"] = "Bearer #{token}"
      get :authenticated

      expect(response.status).to eq(401)
      # expect(controller.__send__(:karimado_access_token)).to be_nil
    end
  end
end
