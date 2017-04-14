require "spec_helper"

RSpec.describe AsJWTAuth do
  it "has a version number" do
    expect(AsJWTAuth::VERSION).not_to be nil
  end

  describe '#verify_jwt' do

    let(:private_key) do
      key = OpenSSL::PKey::EC.new 'prime256v1'
      key.generate_key
    end

    let(:public_key) do
      key = OpenSSL::PKey::EC.new private_key
      key.private_key = nil
      key
    end

    let(:payload) { {} }
    let(:jwt) { JWT.encode payload, private_key, 'ES256' }

    it 'works' do
      result = described_class.verify_jwt jwt, public_key: public_key
      expect(result).to be_truthy
    end
  end
end
