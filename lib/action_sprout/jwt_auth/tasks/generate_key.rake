namespace :action_sprout do
  namespace :jwt_auth do
    desc "Generate a public/private key-pair for use with JWTAuth"

    task :generate_key do
      require 'openssl'
      require 'pathname'

      key = OpenSSL::PKey::EC.new 'prime256v1'
      key.generate_key
      private_key = key.to_pem

      key.private_key = nil
      public_key = key.to_pem

      service_directory = defined?(Rails) ? Rails.root : Pathname.new('.').expand_path
      service_name = service_directory.basename.to_s

      puts "New public/private key generated for use with jwt_auth"
      puts
      puts "Private Key"
      puts "-----------"
      puts
      puts "Add this private key to your project's environment (heroku config:set for production/staging and docker.env for develompent/test)"
      puts
      puts "    PRIVATE_KEY=#{private_key.inspect}"
      puts
      puts "    heroku config:set \"$(echo -e PRIVATE_KEY=#{private_key.inspect})\" -a as-#{service_name}"
      puts
      puts
      puts "Public Key"
      puts "----------"
      puts
      puts "Add this to huckleberry:config/app_keys.yml"
      puts
      puts "    as-#{service_name}: #{public_key.inspect}"
      puts
      puts

    end
  end
end
