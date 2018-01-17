require 'jwt'

module ActionSprout
  module JWTAuth
    class VerifyJWT
      attr_reader :public_key

      def initialize(public_key)
        @public_key = public_key
      end

      def valid?(string)
        JWTBody.call key: public_key, jwt: string
      rescue JWT::DecodeError
        false
      end
    end
  end
end
