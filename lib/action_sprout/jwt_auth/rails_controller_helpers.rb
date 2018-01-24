require 'action_sprout/jwt_auth/get_public_key'

module ActionSprout
  module JWTAuth
    module RailsControllerHelpers
      def verify_jwt!
        if !jwt_authorized?
          debug_jwt = ActionSprout::JWTAuth.debug_jwt jwt_from_request
          logger.warn "ActionSprout::JWTAuth: Unauthorized JWT: #{jwt_from_request} payload=#{debug_jwt} options=#{jwt_options_for_verification}"
          render json: jwt_unauthorized_response_data, status: :unauthorized
        end
      end

      def jwt_authorized?
        key = OpenSSL::PKey::EC.new public_key_for_jwt_auth
        JWTAuth.verify_jwt jwt_from_request, key: key, options: jwt_options_for_verification
      end

      def jwt_from_request
        request.env['HTTP_X_AUTH']
      end

      def jwt_options_for_verification
        request_url_without_query_string = request.base_url + request.path
        { verify_aud: true, aud: request_url_without_query_string }
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
