require 'spec_helper'

RSpec.describe ActionSprout::JWTAuth::JWTHeader do
  include TestKeys

  let(:payload) { {} }
  let(:header) { { 'iss' => 'tests' } }
  let(:jwt) { JWT.encode payload, private_key, 'ES256', header }

  describe '.call' do
    it 'returns the header' do
      header = described_class.call jwt
      expect(header).to eq({
        'iss' => 'tests',
        'alg' => 'ES256',
        'typ' => 'JWT',
      })
    end
  end

  describe '.issuer' do
    it 'returns only the issuer' do
      issuer = described_class.issuer jwt
      expect(issuer).to eq  'tests'
    end
  end
end
