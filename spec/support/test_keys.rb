module TestKeys
  extend RSpec::SharedContext

  let(:private_key) do
    key = OpenSSL::PKey::EC.new 'prime256v1'
    key.generate_key
  end

  let(:public_key) do
    key = OpenSSL::PKey::EC.new private_key
    key.private_key = nil
    key
  end
end
