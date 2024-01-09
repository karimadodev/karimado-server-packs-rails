RSpec.describe Karimado::Concerns::Controllers::Authentication, type: :controller do
  let(:session) { FactoryBot.create(:user_session) }

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
      token = session.authn_token[:access_token]
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
      token = session.authn_token[:access_token]
      Timecop.freeze(2.hours.from_now)
      request.headers["Authorization"] = "Bearer #{token}"
      get :authenticated

      expect(response.status).to eq(401)
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 401 when token revoked" do
      token = session.authn_token[:access_token]
      session.discard!
      request.headers["Authorization"] = "Bearer #{token}"
      get :authenticated

      expect(response.status).to eq(401)
      # expect(controller.__send__(:karimado_access_token)).to be_nil
    end
  end
end
