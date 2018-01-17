require 'spec_helper'

RSpec.describe ActionSprout::JWTAuth::GenerateJWT do
  include TestKeys

  subject { described_class.new key: private_key, issuer: issuer }

  describe '#generate' do
    let(:issuer) { 'as-issuer' }
    let(:jwt) { subject.generate 'the' => 'payload' }

    it 'creates a JWT' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload['the']).to eq 'payload'
    end

    it 'adds an iat' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload['iat']).to be
    end

    it 'adds a jid' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload['jid']).to be
    end

    it 'adds the app name as the issuer' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload['iss']).to eq 'as-issuer'
    end
  end
end
