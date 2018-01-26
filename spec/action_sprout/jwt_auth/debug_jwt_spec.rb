require 'spec_helper'

RSpec.describe ActionSprout::JWTAuth::DebugJWT, '.call' do
  include TestKeys

  let(:payload) { { 'data' => 'example' } }
  let(:jwt) { JWT.encode payload, private_key, 'ES256' }
  let(:options) { {} }

  subject { described_class.call jwt: jwt }

  context 'with a valid JWT' do
    it { is_expected.to eq payload }
  end

  context 'with a jwt that is not really a JWT' do
    let(:jwt) { 'omg-foo' }

    it { expect { subject }.to raise_error(JWT::DecodeError) }
  end

  context 'when no jwt is provided' do
    let(:jwt) { nil }

    it { expect { subject }.to raise_error(JWT::DecodeError) }
  end
end
