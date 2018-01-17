require 'spec_helper'

RSpec.describe ActionSprout::JWTAuth::GenerateJWT do
  include TestKeys

  subject { described_class.new key: private_key, issuer: issuer }

  describe '#generate' do
    let(:issuer) { 'as-issuer' }
    let(:jwt) { subject.generate 'the' => 'payload' }

    it 'creates a JWT' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload).to eq 'the' => 'payload'
    end

    it 'adds an iat to the headers' do
      _payload, headers = JWT.decode jwt, public_key
      expect(headers['iat']).to be
    end

    it 'adds a jid to the headers' do
      _payload, headers = JWT.decode jwt, public_key
      expect(headers['jid']).to be
    end

    it 'adds the app name as the issuer' do
      _payload, headers = JWT.decode jwt, public_key
      expect(headers['iss']).to eq 'as-issuer'
    end
  end
end
