require "spec_helper"

RSpec.describe ActionSprout::JWTAuth do
  include TestKeys

  it "has a version number" do
    expect(ActionSprout::JWTAuth::VERSION).not_to be nil
  end

  describe '#parse_jwt' do
    let(:payload) { { 'example' => 'data' } }
    let(:jwt) { JWT.encode payload, private_key, 'ES256' }

    it 'works' do
      result = described_class.jwt_body jwt, key: public_key
      expect(result).to eq payload
    end
  end

  describe '#generate_jwt' do
    let(:payload) { { 'the' => 'payload' } }

    let(:jwt) { described_class.generate_jwt payload, key: private_key, issuer: 'test-issuer' }

    it 'creates a JWT' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload['the']).to eq 'payload'
    end

    it 'sets the issuer' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload['iss']).to eq 'test-issuer'
    end

    context 'when no issuer is defined' do
      let(:jwt) { described_class.generate_jwt payload, key: private_key }

      context 'when there is no APP_NAME environment variable' do
        before { ENV.delete('APP_NAME') }

        it 'raises an exception' do
          expect { jwt }.to raise_error(ArgumentError, /issuer/)
        end
      end

      context 'when an APP_NAME environment variable is defined' do
        before { ENV['APP_NAME'] = 'test-app' }
        after { ENV.delete('APP_NAME') }

        it 'uses the environment variable APP_NAME' do
          payload, _headers = JWT.decode jwt, public_key
          expect(payload['iss']).to eq 'test-app'
        end
      end
    end

    context 'when no key is defined' do
      let(:jwt) { described_class.generate_jwt payload, issuer: 'test-issuer' }

      context 'when there is no PRIVATE_KEY environment variable' do
        before { ENV.delete('PRIVATE_KEY') }

        it 'raises an exception' do
          expect { jwt }.to raise_error(ArgumentError, /private key/)
        end
      end

      context 'when a PRIVATE_KEY environment variable is defined' do
        let(:private_key_pem) { private_key.to_pem }
        before { ENV['PRIVATE_KEY'] = private_key_pem }
        after { ENV.delete('PRIVATE_KEY') }

        it 'uses the environment variable PRIVATE_KY' do
          payload, _headers = JWT.decode jwt, public_key
          expect(payload).to be
        end

        context 'when the PRIVATE_KEY environment variable has escaped newlines' do
          let(:private_key_pem) { private_key.to_pem.inspect.gsub('"', '') }

          it 'uses the environment variable PRIVATE_KEY, even if it has escaped newlines' do
            payload, _headers = JWT.decode jwt, public_key
            expect(payload).to be
          end
        end

      end

    end
  end

  describe '#verify_jwt' do
    let(:payload) { {} }
    let(:jwt) { JWT.encode payload, private_key, 'ES256' }

    it 'works' do
      result = described_class.verify_jwt jwt, key: public_key
      expect(result).to be_truthy
    end
  end

  describe '#jwt_issuer' do
    let(:payload) { { iss: 'tests' } }
    let(:jwt) { JWT.encode payload, private_key, 'ES256' }

    it 'returns the issuer' do
      issuer = described_class.jwt_issuer jwt
      expect(issuer).to eq 'tests'
    end
  end
end
