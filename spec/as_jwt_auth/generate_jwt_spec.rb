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
  end
end
