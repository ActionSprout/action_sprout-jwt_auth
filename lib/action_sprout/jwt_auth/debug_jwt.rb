require 'jwt'
require 'action_sprout/method_object'

module ActionSprout
  module JWTAuth
    class DebugJWT
      extend ActionSprout::MethodObject
      method_object :jwt

      def call
        payload, _headers = JWT.decode jwt, nil, false

        # Return only the body. Clients can use `ActionSprout::JWTAuth.jwt_header` to get the header.
        payload
      end

    end
  end
end
