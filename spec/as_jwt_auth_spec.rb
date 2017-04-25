require "spec_helper"

RSpec.describe AsJWTAuth do
  include TestKeys

  it "has a version number" do
    expect(AsJWTAuth::VERSION).not_to be nil
  end

  describe '#generate_jwt' do
    let(:jwt) do
      described_class.generate_jwt 'the' => 'payload', key: private_key
    end

    it 'creates a JWT' do
      payload, _headers = JWT.decode jwt, public_key
      expect(payload).to eq 'the' => 'payload'
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
end
