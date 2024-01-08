RSpec.describe Karimado::Concerns::Controllers::Authentication, type: :controller do
  let(:session) { FactoryBot.create(:user_session) }

  controller(ActionController::API) do
    include Karimado::Concerns::Controllers::Authentication

    skip_before_action :authenticate_user!, only: [:anonymous]

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

  describe "#authenticate_user!" do
    it "is expected to response 200 when skip before action" do
      get :anonymous

      expect(response.status).to eq(200)
      expect(controller.__send__(:current_user)).to be_nil
      expect(controller.__send__(:current_user_session)).to be_nil
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 200 when token set" do
      token = session.access_token(expires_in: 1.hour)
      request.headers["Authorization"] = "Bearer #{token}"
      get :authenticated

      expect(response.status).to eq(200)
      expect(controller.__send__(:current_user)).to eq(session.user)
      expect(controller.__send__(:current_user_session)).to eq(session)
      expect(controller.__send__(:karimado_access_token)).to be_a(Karimado::UserSessionAccessToken)
    end

    it "is expected to response 401 when token not set" do
      get :authenticated

      expect(response.status).to eq(401)
      expect(controller.__send__(:current_user)).to be_nil
      expect(controller.__send__(:current_user_session)).to be_nil
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 401 when token expired" do
      token = session.access_token(expires_in: 1.hour)
      Timecop.freeze(2.hours.from_now)
      request.headers["Authorization"] = "Bearer #{token}"
      get :authenticated

      expect(response.status).to eq(401)
      expect(controller.__send__(:current_user)).to be_nil
      expect(controller.__send__(:current_user_session)).to be_nil
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end

    it "is expected to response 401 when token format invalid" do
      request.headers["Authorization"] = "Bearer abcdef"
      get :authenticated

      expect(response.status).to eq(401)
      expect(controller.__send__(:current_user)).to be_nil
      expect(controller.__send__(:current_user_session)).to be_nil
      expect(controller.__send__(:karimado_access_token)).to be_nil
    end
  end
end
