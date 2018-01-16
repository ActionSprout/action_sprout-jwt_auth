require 'httparty'
require 'addressable/template'
require 'action_sprout/method_object'
require 'active_support/all'

module AsJWTAuth
  class GetPublicKey
    extend ActionSprout::MethodObject

    # This default cache key should work well in most scenarios. While it will
    # not persist across restarts or web server processes, it is _much_ faster
    # than reading from memcached or redis and it is assumed that the key
    # server itself is fairly fast.
    DEFAULT_CACHE = ActiveSupport::Cache::MemoryStore.new
    method_object :jwt, http_client: HTTParty, cache: DEFAULT_CACHE

    def call
      assert jwt_app_name, 'This JWT is missing an issuer'

      DEFAULT_CACHE.fetch(cache_key) do
        get_public_key
      end
    end

    private

    def assert(value, message)
      fail message unless value
    end

    def cache_key
      ['as_jwt_auth/public_keys', jwt_app_name]
    end

    def get_public_key
      response = make_request
      assert response.success?, "There was an issue loading the public key for #{jwt_app_name.inspect}"
      key_from_response response
    end

    def make_request
      http_client.get public_key_url, headers: { 'X-Auth' => jwt_for_request }
    end

    def key_from_response(response)
      response.parsed_response.dig 'data', 'attributes', 'key'
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
