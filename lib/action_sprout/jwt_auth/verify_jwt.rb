require 'jwt'

module ActionSprout
  module JWTAuth
    class VerifyJWT
      attr_reader :public_key, :options

      def initialize(public_key, options: {})
        @public_key = public_key
        @options = options
      end

      def valid?(string)
        JWTBody.call key: public_key, jwt: string, options: options
      rescue JWT::DecodeError
        false
      end
    end
  end
end
