RSpec.describe Karimado::Concerns::Controllers::Rendering, type: :controller do
  let(:session) { FactoryBot.create(:user_session) }

  controller(ActionController::API) do
    include Karimado::Concerns::Controllers::Rendering

    def success
      render_success
    end

    def success_data
      render_success({a: 1})
    end

    def failure
      render_failure
    end

    def failure_code
      render_failure(:unauthorized)
    end

    def failure_message
      render_failure("Oops")
    end

    def failure_code_message
      render_failure(:unauthorized, "Login Required")
    end
  end

  before do
    routes.draw do
      get "/anonymous/success"
      get "/anonymous/success_data"
      get "/anonymous/failure"
      get "/anonymous/failure_code"
      get "/anonymous/failure_message"
      get "/anonymous/failure_code_message"
    end
  end

  describe "#render_success" do
    it "is expected to return #success" do
      get :success

      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq({
        "code" => 0,
        "message" => "OK",
        "data" => {}
      })
    end

    it "is expected to return #success with data" do
      get :success_data

      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq({
        "code" => 0,
        "message" => "OK",
        "data" => {"a" => 1}
      })
    end
  end

  describe "#render_failure" do
    it "is expected to return #failure" do
      get :failure

      expect(response.status).to eq(500)
      expect(response.parsed_body).to eq({
        "code" => 1,
        "message" => "ERROR"
      })
    end

    it "is expected to return #failure with code" do
      get :failure_code

      expect(response.status).to eq(500)
      expect(response.parsed_body).to eq({
        "code" => 10401,
        "message" => "Unauthorized"
      })
    end

    it "is expected to return #failure with message" do
      get :failure_message

      expect(response.status).to eq(500)
      expect(response.parsed_body).to eq({
        "code" => 1,
        "message" => "Oops"
      })
    end

    it "is expected to return #failure with code & message" do
      get :failure_code_message

      expect(response.status).to eq(500)
      expect(response.parsed_body).to eq({
        "code" => 10401,
        "message" => "Login Required"
      })
    end
  end
end
