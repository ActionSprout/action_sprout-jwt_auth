require "spec_helper"

RSpec.describe AsJWTAuth do
  include TestKeys

  it "has a version number" do
    expect(AsJWTAuth::VERSION).not_to be nil
  end

  describe '#generate_jwt' do
    let(:payload) { { 'the' => 'payload' } }

    let(:jwt) { described_class.generate_jwt payload, key: private_key, issuer: 'test-issuer' }

    it 'creates a JWT' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload).to eq 'the' => 'payload'
    end

    it 'sets the issuer' do
      _payload, headers = JWT.decode jwt, public_key
      expect(headers['iss']).to eq 'test-issuer'
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

  describe '#jwt_header' do
    let(:payload) { {} }
    let(:jwt) { JWT.encode payload, private_key, 'ES256', iss: 'tests' }

    it 'returns the header' do
      header = AsJWTAuth.jwt_header jwt
      expect(header).to eq({
        'iss' => 'tests',
        'alg' => 'ES256',
        'typ' => 'JWT',
      })
    end
  end
end
