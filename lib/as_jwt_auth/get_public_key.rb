require 'httparty'
require 'addressable/template'

module AsJWTAuth
  class GetPublicKey
    def self.call(jwt, http_client: HTTParty)
      auth_url_template = Addressable::Template.new(ENV.fetch('JWT_KEY_SERVER_URL_TEMPLATE'))
      jwt_app_name = AsJWTAuth::JWTHeader.issuer jwt
      assert jwt_app_name, 'This JWT is missing an issuer'
      jwt_for_request = AsJWTAuth.generate_jwt
      url = auth_url_template.expand(issuer: jwt_app_name).to_s
      response = http_client.get(url, headers: { 'X-Auth' => jwt_for_request })
      assert response.success?, "There was an issue loading the public key for #{jwt_app_name.inspect}"
      response.parsed_response.dig(*%w[ data attributes key ])
    end

    def self.assert(value, message)
      fail message unless value
    end
  end
end
