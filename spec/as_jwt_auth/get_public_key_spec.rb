require 'spec_helper'
require 'as_jwt_auth/get_public_key'

RSpec.describe AsJWTAuth::GetPublicKey do
  include TestKeys

  let(:payload) { {} }
  let(:header) { { 'iss' => 'test-issuer' } }
  let(:jwt) { JWT.encode payload, private_key, 'ES256', header }
  let(:key_server_url_template) { 'http://key-server/api/keys/{issuer}' }

  let(:client_app_name) { 'client-issuer' }
  let(:client_private_key) { private_key.to_pem }
  let(:http_client) { double 'http_client' }

  shared_context 'key server http request' do
    let(:http_success) { true }

    let(:http_client_response) { double 'http_client_response', success?: http_success, parsed_response: http_parsed_response }

    let(:response_public_key) { 'the-public-key' }
    let(:http_parsed_response) { {
      'data' => { 'attributes' => { 'key' => response_public_key } },
    } }

    before do
      allow(http_client).to receive(:get).with('http://key-server/api/keys/test-issuer', headers: hash_including('X-Auth')).and_return http_client_response
    end
  end

  describe '.call' do
    before do
      ENV['APP_NAME'] = client_app_name if client_app_name
      ENV['PRIVATE_KEY'] = client_private_key if client_private_key
      ENV['JWT_KEY_SERVER_URL_TEMPLATE'] = key_server_url_template if key_server_url_template
    end

    after do
      ENV.delete('APP_NAME')
      ENV.delete('PRIVATE_KEY')
      ENV.delete('JWT_KEY_SERVER_URL_TEMPLATE')
    end

    subject { described_class.call jwt: jwt, http_client: http_client }

    context 'happy path' do
      include_context 'key server http request'

      it 'returns the public key' do
        expect(subject).to eq 'the-public-key'
      end
    end

    context 'when the key server url template is not defined' do
      let(:key_server_url_template) { nil }

      it 'raises an error' do
        expect { subject }.to raise_error(KeyError, /JWT_KEY_SERVER_URL_TEMPLATE/)
      end
    end

    context 'when the jwt does not have an issuer' do
      let(:header) { {} }

      it 'raises an error' do
        expect { subject }.to raise_error(RuntimeError, /JWT.*issuer/)
      end
    end

    context 'when the http requset to the key service responds with anything other than success' do
      include_context 'key server http request'
      let(:http_success) { false }

      it 'raises an error' do
        expect { subject }.to raise_error(RuntimeError, /There was an issue loading the public key for "test-issuer"/)
      end
    end

    context 'when the client does not have an APP_NAME set' do
      let(:client_app_name) { nil }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, /APP_NAME/)
      end
    end

    context 'when the client does not have an PRIVATE_KEY set' do
      let(:client_private_key) { nil }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, /PRIVATE_KEY/)
      end
    end
  end

end
