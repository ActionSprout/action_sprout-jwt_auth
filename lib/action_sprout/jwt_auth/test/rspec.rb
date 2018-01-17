require 'action_sprout/jwt_auth/test/controller_helpers'

RSpec.configure do |config|
  config.include ActionSprout::JWTAuth::Test::ControllerHelpers, type: :controller

  RSpec.shared_examples 'a JWT authorized request' do
    let(:jwt) { 'A.JWT' }
    let(:expected_response_code) { 200 }

    before do
      set_jwt_auth jwt, jwt_result: jwt_result
    end

    NO_RESPONSE_FAILURE_MESSAGE = <<-MESSAGE.strip_heredoc
      Using the shared example 'a JWT authorized request' requires that a request be made.

      The request can either be in a `before` block, or defined as `let(:request)`.

      For example:

          it_should_behave_like 'a JWT authorized request' do
            let(:response) { get :index }
          end

      Or:

         context 'the index page' do
           let(:response) { get :index }
           it_should_behave_like 'a JWT authorized request'
         end

      If you are seeing this error and have defined a request, it is possible that your
      request is raising an exception. Check rspec results for other exceptions.
    MESSAGE

    after do
      fail NO_RESPONSE_FAILURE_MESSAGE unless response.sent?
    end

    context 'with a good JWT' do
      let(:jwt_result) { {} }

      it 'is authorized' do
        expect(response).to be_success
      end
    end

    context 'with a bad JWT' do
      let(:jwt_result) { false }

      it 'is unauthorized' do
        expect(response).to be_unauthorized
      end
    end
  end
end
