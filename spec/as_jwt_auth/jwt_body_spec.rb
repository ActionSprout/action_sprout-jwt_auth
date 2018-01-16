require 'spec_helper'

RSpec.describe AsJWTAuth::JWTBody, '.call' do
  include TestKeys

  let(:payload) { { 'data' => 'example' } }
  let(:jwt) { JWT.encode payload, private_key, 'ES256' }

  subject { described_class.call jwt: jwt, key: public_key }

  context 'with a valid JWT' do
    it { is_expected.to eq payload }
  end

  context 'with a completely invalid jwt' do
    let(:jwt) { 'omg-foo' }

    it { expect { subject }.to raise_error(JWT::DecodeError) }
  end

  context 'when no jwt is provided' do
    let(:jwt) { nil }

    it { expect { subject }.to raise_error(JWT::DecodeError) }
  end

  context 'when the jwt is encoded with the wrong private key' do
    let(:public_key) do
      key = OpenSSL::PKey::EC.new 'prime256v1'
      key.private_key = nil
      key
    end

    it { expect { subject }.to raise_error(JWT::DecodeError) }
  end
end
