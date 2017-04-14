require 'jwt'

module AsJWTAuth
  class VerifyJWT
    def self.call(string)
      new.valid? string
    end

    def initialize(public_key)
      @public_key = public_key
    end

    def valid?(string)
      JWT.decode string, public_key, true, jwt_options
    rescue JWT::DecodeError
      false
    end

    private

    attr_reader :public_key

    def jwt_options
      { algorithm: 'ES256' }
    end

    # TODO: Comment on using this in the future
    # aud: expected_audience, verify_aud: true

  end
end
