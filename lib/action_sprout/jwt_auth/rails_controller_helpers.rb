require 'action_sprout/jwt_auth/get_public_key'

module ActionSprout
  module JWTAuth
    module RailsControllerHelpers
      def verify_jwt!
        if !jwt_authorized?
          logger.warn "ActionSprout::JWTAuth: Unauthorized JWT: #{jwt_from_request}"
          render json: jwt_unauthorized_response_data, status: :unauthorized
        end
      end

      def jwt_authorized?
        key = OpenSSL::PKey::EC.new public_key_for_jwt_auth
        JWTAuth.verify_jwt jwt_from_request, key: key
      end

      def jwt_from_request
        request.env['HTTP_X_AUTH']
      end

      def public_key_for_jwt_auth
        JWTAuth::GetPublicKey.call jwt: jwt_from_request
      end

      def jwt_unauthorized_response_data
        {
          errors: [{
            status: '401',
            title: 'Unauthorized',
            detail: 'This request is unauthorized.',
          }],
        }
      end
    end
  end
end
