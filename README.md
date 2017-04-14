# AsJWTAuth

This gem provides a method for handling JWT authentication between AS services.

## Installation

Add this line to your application's Gemfile:

```ruby
# make sure gemfury source is also in this file.
gem 'as_jwt_auth'
```

And then execute:

    $ bundle

## Usage

Here is an example of how AsJWTAuth is used in ActionSprout/fern and ActionSprout/waterleaf.

```ruby
# Generate a JWT in fern
jwt_string = AsJWTAuth.generate_jwt({ 'aud' => 'as-waterleaf' }, key: Fern.private_key)

# Verify that JWT in waterleaf
AsJWTAuth.verify_jwt jwt_string, key: ferns_public_key # => true or false
```

## Roadmap

Currently, each service so far already knows what other service is expected to
be making the call, but in the future, it may be that an endpoint is accessible
by more than one service. In this case, the service will need to determine who
has made the call in order to use the correct public key to verify with.

When we have that requirement, we plan to add logic and configuration to
AsJWTAuth to handle finding the correct public key.

## Development

#### Setup
1. Check out repo `https://github.com/ActionSprout/as_jwt_auth.git`
2. `bin/setup` (this runs `bundle install`)
3. Run tests with `rake spec`

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

**Use locally**
To install this gem into a local project add to your Gemfile
```ruby
gem 'as_jwt_auth', path: 'relative/path/to/gem/repo'
```
and then `bundle install` in that project. Remember to add the Gemfury `source` before
using in production.

#### Release a new Version
Update the version number in `lib/as_jwt_auth/version.rb` and make you final version change commit.
Create a release tag with `gem_push=no rake release`.

Make sure you have the git remote `fury` added (can be called anything).

    $ git remote add fury https://PASSWORD@repo.fury.io/ORGANIZATION/


To release the new verison we push to our Gemfury repo.

    $ git push fury master
