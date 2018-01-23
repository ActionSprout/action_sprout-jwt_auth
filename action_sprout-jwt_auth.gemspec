# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_sprout/jwt_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "action_sprout-jwt_auth"
  spec.version       = ActionSprout::JWTAuth::VERSION
  spec.authors       = ["Kyle Rader", "Amiel Martin"]
  spec.email         = ["kyle@actionsprout.com", "amiel@actionsprout.com"]

  spec.summary       = %q{A JWT Auth Gem}
  spec.description   = %q{This gem provides a method for handling JWT authentication between AS services.}
  spec.homepage      = "https://github.com/ActionSprout/action_sprout-jwt_auth"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'jwt', '~> 1.5'
  spec.add_dependency 'addressable', '~> 2'
  spec.add_dependency 'httparty', '~> 0.15'
  spec.add_dependency 'action_sprout-method_object', '~> 0'
  spec.add_dependency 'activesupport', '> 4'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
