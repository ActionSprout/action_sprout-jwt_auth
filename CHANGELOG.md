# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2018-01-29

### Security

- Verify the `aud` claim by default when using automatic public key selection (#14)

  This resolves a security concern introduced in 0.4.0. To upgrade, make sure
  each service that uses automatic public key selection is upgraded to at least
  0.4.1 before upgrading the key server to 0.5.0.

  When generating keys, it is now required to add an `aud` claim with the url
  of the request. See the [`aud` verification section of the README] for more
  specific instructions.

### Fixed

- Fix redefined const warning (#13)
- Fix gemspec warnings by being more specific about dependencies (#12)

### Added

- Better logging for unauthorized JWTs

### [0.4.1] - 2018-01-19

### Added

- Include the `aud` claim when requesting a public key for automatic public key
  selection (#10)

  This is in preparation for 0.5.0 and is provided as an intermidiate step to
  upgrade to 0.5.0 to avoid circular or deep dependencies from allowing any one
  server from upgrading to 0.5.0 quickly.

## [0.4.0] - 2018-01-17

### Changed

- **Name change**: The name of this gem changed from `as_jwt_auth` to
  `action_sprout-jwt_auth` (#7)

  Therefore, the base module is now `ActionSprout::JWTAuth`, as opposed to
  `AsJWTAuth`. All references to `AsJWTAuth` will need to be updated to
  `ActionSprout::JWTAuth`.

### Fixed

- Move automatic claims to the JWT payload (#8)

  Originally, I incorrectly thought that these claims should be in the header
  and I was wrong. In order to take advantage of verification provided by the
  JWT gem, these claims need to be stored in the payload and not the header.

### Added

- **Automatic public key selection**: When using the `verify_jwt!`
  before_action, JWTAuth can determine the issuer from the JWT and use that to
  request a public key from a key server. (#6)

  - Use the environment variable `JWT_KEY_SERVER_URL_TEMPLATE` to configure the
    public key server endpoint
  - This endpoint should be protected with the same gem using `verify_jwt!`
  - The result is cached in an `ActiveSupport::Cache::MemoryStore`
  - **SECURITY NOTE**: This feature is safe only if JWTs signed with keys
    existing in the key server's database are only used internally (meaning
    they are not shared with clients)

    In the case that these JWTs are shared with clients (such as a smart web client, for example), and the corresponding public key is available from the key server, then any server using `verify_jwt!` that does not have specific scoping rules will be vulnerable.

    UPDATE: Please upgrade to 0.5.0 for a security fix.

- `ActionSprout::JWTAuth.jwt_body` returns the body of the JWT without the
  header

### Removed

- `AsJWTAuth.jwt_header` has been removed in favor of
  `ActionSprout::JWTAuth.jwt_issuer`

  - Before, the only existing use of `jwt_header` was to get the issuer
  - Now, the issuer is no longer even stored in the header

## [0.3.1] - 2018-01-11

### Added

- Automatically set private key and issuer using environment variables (#4)

  When generating a JWT, if the `key` and/or `issuer` options are missing, this
  gem will attempt to use values from `ENV` instead, namely `APP_NAME` for
  `issuer` and `PRIVATE_KEY` for `key`.

### Deprecated

- This is the last version of this gem to be released under the name
  `as_jwt_auth`

  - The next version will be `action_sprout-jwt_auth v0.4.0`
  - With the name change, there will probably be a fair amount of internal
    refactoring and potentially breaking changes.

## [0.3.0] - 2018-01-10

### Changed

- Require an `issuer` when generating a JWT

### Added

- Rails plugin (#3)

  - Controller helper `verify_jwt!` makes a good before_action
  - Add Rails testing helpers for testing controllers using `verify_jwt!`

- Add `AsJWTAuth.jwt_header` to make it easy to inspect the JWT header
- Automatically add `iss`, `jid`, and `iat` claims when generating a JWT

## [0.2.1] - 2017-04-25

### Fixed

- Fix an issue where the jwt gem might not be correctly loaded when using `#generate_jwt` (#2)

## 0.2.0 - 2017-04-14

### Added

- Initial gem with `#verify_jwt` and `#generate_jwt`

[`aud` verification section of the README]: https://github.com/ActionSprout/action_sprout-jwt_auth#aud-verification
[**Automatic public key selection**]: https://github.com/ActionSprout/action_sprout-jwt_auth#automatic-public-key-selection

[Unreleased]: https://github.com/ActionSprout/action_sprout-jwt_auth/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/ActionSprout/action_sprout-jwt_auth/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/ActionSprout/action_sprout-jwt_auth/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/ActionSprout/action_sprout-jwt_auth/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/ActionSprout/action_sprout-jwt_auth/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/ActionSprout/action_sprout-jwt_auth/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/ActionSprout/action_sprout-jwt_auth/compare/v0.2.0...v0.2.1
