require 'spec_helper'

RSpec.describe AsJWTAuth::VerifyJWT do
  include TestKeys

  # In the future, we plan to support multiple audiences. When that happens,
  # `aud` will be required.
  let(:payload) { { aud: 'as-example' } }
  let(:jwt) { JWT.encode payload, private_key, 'ES256' }

  describe '#valid?' do
    subject { described_class.new public_key }

    context 'with a valid JWT' do
      it { is_expected.to be_valid jwt }
    end

    context 'with a completely invalid jwt' do
      let(:jwt) { 'omg-foo' }

      it { is_expected.to_not be_valid jwt }
    end

    context 'when no jwt is provided' do
      let(:jwt) { nil }

      it { is_expected.to_not be_valid jwt }
    end

    context 'when the jwt is encoded with the wrong private key' do
      let(:public_key) do
        key = OpenSSL::PKey::EC.new 'prime256v1'
        key.private_key = nil
        key
      end

      it { is_expected.to_not be_valid jwt }
    end
  end

end
