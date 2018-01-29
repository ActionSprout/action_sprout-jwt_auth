require 'jwt'
require 'action_sprout/method_object'

module ActionSprout
  module JWTAuth
    class JWTBody
      extend ActionSprout::MethodObject
      method_object :jwt, :key, :options

      def call
        payload, _headers = JWT.decode jwt, key, true, jwt_options

        # Return only the body. Clients can use `ActionSprout::JWTAuth.jwt_header` to get the
        # header without verifying the JWT signature.
        payload
      end

      private

      def jwt_options
        options.merge algorithm: 'ES256'
      end

    end
  end
end
