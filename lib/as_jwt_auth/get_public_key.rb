require 'httparty'
require 'addressable/template'
require 'action_sprout/method_object'

module AsJWTAuth
  class GetPublicKey
    extend ActionSprout::MethodObject
    method_object :jwt, http_client: HTTParty

    def call
      assert jwt_app_name, 'This JWT is missing an issuer'

      response = make_request

      assert response.success?, "There was an issue loading the public key for #{jwt_app_name.inspect}"

      key_from_response response
    end

    private

    def assert(value, message)
      fail message unless value
    end

    def make_request
      http_client.get public_key_url, headers: { 'X-Auth' => jwt_for_request }
    end

    def key_from_response(response)
      response.parsed_response.dig(*%w[ data attributes key ])
    end

    def public_key_url
      auth_url_template.expand(issuer: jwt_app_name).to_s
    end

    def auth_url_template
      Addressable::Template.new ENV.fetch('JWT_KEY_SERVER_URL_TEMPLATE')
    end

    def jwt_app_name
      @_jwt_app_name ||= AsJWTAuth::JWTHeader.issuer jwt
    end

    def jwt_for_request
      @_jwt_for_request ||= AsJWTAuth.generate_jwt
    end
  end
end
