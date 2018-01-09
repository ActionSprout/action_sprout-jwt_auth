require 'spec_helper'

RSpec.describe AsJWTAuth::GenerateJWT do
  include TestKeys

  subject { described_class.new private_key }

  describe '#generate' do
    let(:jwt) do
      subject.generate 'the' => 'payload'
    end

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


    context 'when specifying the app' do
      subject { described_class.new private_key, app: 'as-fireweed' }

      it 'adds the app name as the issuer' do
        _payload, headers = JWT.decode jwt, public_key
        expect(headers['iss']).to eq 'as-fireweed'
      end
    end
  end
end
