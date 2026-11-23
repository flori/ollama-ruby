# Changes

## 2026-11-18 v1.27.2

### Fixes
- Explicitly require `json/generic_object` in `response.rb` to resolve the
  superclass reference, as `json` **3.x** no longer autoloads
  `JSON::GenericObject`.

## 2026-11-18 v1.27.1

### Build & CI
- Updated the `gem_hadar` development dependency requirement in
  `ollama-ruby.gemspec` from `>= 2.24.0` to `>= 2.24.1`.

## 2026-11-18 v1.27.0

### Improvements
- Relaxed the `json` runtime dependency constraint from `~> 2.0` to
  `>= 2.0`, `< 4`.
- Added `json-generic_object` as a runtime dependency to ensure
  `JSON::GenericObject` availability on `json` 3.x.

### Build & CI
- Bumped the `gem_hadar` development dependency requirement to
  `>= 2.24.0`.

## 2026-11-17 v1.26.4

### Fixes
- Handle `nil` `@total` in `Ollama::Handlers::Progress#call` when the server sends a
  `success` status without prior progress, preventing a `NoMethodError`.

### Build & CI
- Bump `gem_hadar` development dependency minimum version constraint from **2.21.0**
  to **2.22.1**.

### Testing
- Add specs for `Ollama::Handlers::Progress` covering success with and without
  prior progress.

## 2026-11-16 v1.26.3

### Breaking
- Bumped the `infobar` dependency requirement from `~> 0.8` to `~> 0.15` in
  the `Rakefile` and `ollama-ruby.gemspec`. This change is required to ensure
  the inclusion of the `Display#newline` position fix, which was not present
  in versions `0.8` through `0.14`.

## 2026-11-15 v1.26.2

### Fixes
- Call `infobar.finish` and `infobar.newline` in `Progress#call` when
  `response.status == 'success'` to commit the progress bar to scrollback and
  move the cursor below it, preventing subsequent output from overwriting the
  bar.

### Improvements
- Replaced `getconf _NPROCESSORS_ONLN` with `nproc` for `bundle install`
  job count detection.

### Build & CI
- Added `git config --global --add safe.directory /work` to resolve
  permission errors in CI environments.

### Documentation
- Replaced the YARD cheatsheet in `.contexts/yard.md` with a comprehensive
  `Document` class example.
- Updated instructions to generate only YARD comment blocks, excluding
  executable code.
- Defined rules to omit `@return [void]` clauses.
- Demonstrated usage of `@!attribute`, `@overload`, `@yield`, and
  `@deprecated` tags.

## 2026-11-13 v1.26.1

### Fixes
- Buffer JSONL lines in the streaming path of
  `Ollama::Client#request` to prevent `JSON::ParserError` when
  the server flushes partial JSON lines.

### Improvements
- Update the chat continuation hint in `bin/ollama_cli` to
  suggest using the `/input` command instead of the removed `-c`
  flag.

### Build & CI
- Raise minimum development dependency `gem_hadar` to **2.21.0**.
- Update `rubygems_version` to **4.0.24** in `ollama-ruby.gemspec`.

## 2026-10-23 v1.26.0

### Features
- Added `Ollama::BaseURL` module with a `base_url` method to normalize host
  specifications into `URI` objects, automatically prepending `http://` when no
  scheme is present.
- Exposed `Ollama.base_url` as the public entry point for resolving base URLs.

### Fixes
- Updated `bin/ollama_browse` to strip the tag suffix from the model argument
  before querying the tags URL, preventing 404 errors for models with tags.

### Improvements
- Replaced inline base URL construction in `bin/ollama_cli`,
  `bin/ollama_console`, `bin/ollama_ps`, and `bin/ollama_update` with calls to
  `Ollama.base_url`.

### Testing
- Added `spec/ollama/base_url_spec.rb` to cover bare host:port strings, IP:port,
  full `http://`/`https://` URLs, `URI` object pass-through, and `fallback:
  false` behavior.

### Documentation
- Added a "Vision (Multimodal) Models" section to the README with a workflow
  for importing vision models using `push_blob` and `create`.
- Added a note clarifying that `push_blob` returns `sha256:`-prefixed digests
  and that `files` map keys must be basenames.
- Added a tip to verify exact filenames via the Hugging Face API
  `siblings[].rfilename`.
- Simplified the `show`/`create` parameter-inheritance example in the README to
  use Ruby 3.1+ hash shorthand.
- Fixed various typos in the README, including `&amp;` to `&`, "the the",
  "choosen" to "chosen", "commdand(s)" to "command(s)", and "can be be created"
  to "can be created".

## 2026-10-17 v1.25.0

### Fixes
- `DTO#to_hash` now only rejects `nil` attribute values instead of also
  rejecting empty collections, so empty hashes and arrays such as
  `properties: {}` or `required: []` survive serialization
- `Property#initialize` converts `enum` with `enum&.to_a` instead of
  `Array(enum)`, leaving `enum` as `nil` when not provided so no empty `enum:
  []` leaks into the output

## 2026-10-16 v1.24.0

### Features
- Add `Options.from_string` to parse `show`-format parameter strings
  with type inference for `Boolean`, `Integer`, `Float`, and `Array`
  types.
- Add `draft_num_predict: Integer` to the `@@types` registry and freeze
  the `@@types` hash to prevent accidental mutation.

### Fixes
- Fix an infinite loop in `bin/ollama_ps` by correcting the `while`
  condition to `duration > 0` and ensuring explicit exit codes (`exit 0`
  for success, `exit 1` for failure).
- Add `rescue Interrupt` handling in `bin/ollama_ps` for clean `Ctrl+C`
  exit messages.
- Fix backtick formatting for `Q4_K_M` and `F16` in the `ollama_ps` QUANT
  column documentation.

### Documentation
- Update YARD documentation for the `think` parameter in
  `Ollama::Commands::Chat` and `Ollama::Commands::Generate` to include
  `"max"` as an accepted thinking level.
- Document the `show` → `create` parameter import workflow in
  `README.md`.
- Add `-i INTERVAL` to the `ollama_ps` usage block in `README.md`.

### Improvements
- Remove vim modeline comments from `Gemfile` and `Rakefile`.

## 2026-08-12 v1.23.2

### Fixes
- Replace `clear_screen` with `move_home` and
  `erase_in_display(nil)` in `bin/ollama_ps` and
  `lib/ollama/handlers/markdown.rb` to prevent tmux flicker.

### Build & CI
- Update `gem_hadar` development dependency to **>= 2.18.0**.

### Testing
- Update `spec/ollama/handlers/markdown_spec.rb` to expect the new
  ANSI escape sequences.

## 2026-07-23 v1.23.1

### Improvements
- Updated the `tins` gem dependency to **~> 1.55**.

## 2026-07-23 v1.23.0

### Features
- Add support for nested properties in tool definitions by
  introducing the `properties` attribute to
  `Ollama::Tool::Function::Parameters::Property`.
- Add support for array types in tool property definitions via the
  `items` attribute in
  `Ollama::Tool::Function::Parameters::Property`.
- Implement shallow `to_hash` and recursive `as_json` in
  `Ollama::DTO` to ensure deep serialization into primitives,
  including integration of `Tins::DeepTransform`.

### Build & CI
- Increase the minimum required version of the `tins` gem to
  **1.54**.

### Testing
- Expand `spec/ollama/tool_spec.rb` with test cases for nested
  property serialization.
- Add test cases for simple and complex array property
  serialization in `spec/ollama/tool_spec.rb`.

### Documentation
- Move the "Importing Custom Models" section into its own dedicated
  section in `README.md`.

## 2026-06-21 v1.22.0

### Features
- Added support for blob uploads and management via `Ollama::Client#upload_file`
  and `Ollama::Commands::PushBlob`.
- Introduced `Ollama::Digester` for SHA256 binary hashing, featuring
  `compute_digest` for IO streams and a `prefix_sha256` utility for conditional
  digest formatting.
- Added `Ollama::Client#blob_exists?` and `Ollama::Commands::BlobExists` to
  verify blobs via the API.
- Added visual progress tracking to digest computation using `infobar`, IEC
  units, and braille spinner frames.

### Improvements
- Mapped network exceptions (`Excon::Errors::SocketError`,
  `Excon::Errors::Timeout`, and `Excon::Error`) to internal `Ollama::Errors`.
- Updated `Ollama::Handlers::Concern` to change `result` from an `attr_reader`
  to an `attr_accessor`.
- Added a `skip_doc` option to `Ollama::Client::Command.command` to suppress
  automatic documentation for internal commands.
- Refactored `Ollama::Handlers::Progress#message` to return a configuration
  hash instead of a string, enabling `:braille7` spinner support.

### Documentation
- Added an "Importing Custom Models" section to the `README.md`, documenting
  the workflow using `push_blob` and `create` with Ruby **3** shorthand syntax
  examples.
- Enhanced YARD documentation for `prefix_sha256` and internal command
  options.

### Testing
- Added tests for `Ollama::Digester`, `Ollama::Commands::BlobExists`,
  `Ollama::Commands::PushBlob`, and `Ollama::Client#upload_file`.
- Fixed formatting in `show_spec.rb`.

## 2026-03-20 v1.21.0

### Features
- Added `template` accessor to `Ollama::Commands::Create`
- Added `to_json` method to `Ollama::Image` class

### Build & CI
- Updated `terminal-table` dependency to `>= 3.0`

## 2026-03-20 v1.20.0

### Features
- Added `tool_calls` and `tool_name` support to `Ollama::Message`, including JSON serialization and normalization.
- Added `dimensions` keyword argument and attribute to `Ollama::Commands::Embeddings`.

### Testing
- Created `.rspec` file to configure `--force-color` and automatically require `spec_helper`.
- Removed explicit `require 'spec_helper'` statements from all spec files.
- Added `.envrc` to define the `OLLAMA_CHAT_TOOLS_TEST_RUNNER` environment variable.
- Added `.utilsrc` to configure development tools, search, discovery, and code indexing.

## 2026-03-08 v1.19.2

### Fixes
- Prevent negative sleep values in `ollama_ps` by clamping the
  `duration` variable.

### Improvements
- Add a rescue block to the `ollama_ps` polling loop to handle
  runtime errors gracefully.

## 2026-03-04 v1.19.1

### Fixes
- Fixed the `ps` command to fetch models inside the loop to
  prevent stale data between refresh intervals.

## 2026-03-04 v1.19.0

### Features
- Added API key support to the Ollama client, allowing it to be passed via
  environment variables to `bin/ollama_cli` and `bin/ollama_console`.
- Added an `-i` flag to `ollama_ps` to display the model table at a specified
  interval.

### Improvements
- Improved progress output formatting to display bytes using IEC prefixes.
- Reformatted YARD documentation to improve indentation consistency.

### Build & CI
- Updated the test harness to use `bundle exec rake spec` and manage `Gemfile.lock`
  cleanup.
- Updated development dependencies for `all_images` and `gem_hadar`.
- Enabled the `ruby:4.0-alpine` image in the build matrix.
- Added `changelog` configuration to the Rakefile for automated generation.

### Testing
- Added `api_key` tests to `spec/ollama/client_spec.rb`.
- Implemented a `protect_env` module in `spec/spec_helper.rb` to preserve
  environment variables during tests.

## 2025-12-19 v1.18.0

### Documentation
- Updated the project changelog to record the **1.18.0** release notes.

### Build & CI
- Updated the `gem_hadar` development dependency from **2.8** to
  **2.9**.

## 2025-12-19 v1.17.0

### Breaking
- Relaxed the `required_ruby_version` constraint from "~> 3.1" to ">= 3.1" to allow usage with **Ruby 3.1** and higher, including **4.0**.

### Improvements
- Replaced `bundle update` with `bundle update --all` in the update command.
- Added **4.0-rc** release candidate to the Ruby version matrix in the test configuration (commented out).

### Documentation
- Enhanced `Ollama::Options` class with detailed inline comments for all configuration parameters.
- Updated the documentation link format from `.md` to `.mdx`.

## 2025-12-09 v1.16.0

### Features
- Added the `Ollama::Errors::BadRequestError` class to handle HTTP 400
  status codes.
- Updated `Ollama::Client#request` to raise `BadRequestError` when the
  server responds with a 400 status.

### Testing
- Added a test case to verify `Ollama::Client` raises `BadRequestError`
  for 400 status codes.

### Documentation
- Documented the new `BadRequestError` class with an example usage for
  think mode errors.

## 2025-12-04 v1.15.0

### Features
- Added `-I` flag to `ollama_cli` for sending images to visual models.
- Enabled support for multiple image files via repeated `-I` flags in
  `ollama_cli`.
- Integrated image handling with the `Ollama::Image` infrastructure.
- Added `-f` option to `ollama_ps` to support `json` and `yaml` output
  formats.
- Added `-h` flag to `ollama_ps` for displaying usage information.
- Refactored `ollama_ps` into `fetch_ps_models`, `interpret_models`, and
  `ps_table` methods.

### Improvements
- Updated `ollama_ps` to use `Tins::GO` for improved command-line argument
  parsing.
- Implemented dynamic table headings in `ollama_ps` based on model data keys.
- Added safe navigation (`&.`) for optional model fields in `ollama_ps`.
- Updated `ollama_cli` documentation to include debug mode (`-d`) and version
  info (`-i`) options.

### Documentation
- Added documentation for the `ollama_ps` executable utility in the README.
- Updated the README with image support documentation and usage examples for
  `ollama_cli`.

## 2025-12-03 v1.14.0

### Features
- Added `as_json` method to `Ollama::Image` class that returns a
  base64-encoded string for Ollama API compatibility.

### Testing
- Added a test case verifying that `image.to_json` produces a quoted
  base64 string.

### Documentation
- Documented the behavior of `as_json` for JSON serialization
  compatibility.

## 2025-12-03 v1.13.0

### Fixes
- Updated `Ollama::Image#for_string` to use `Base64.strict_encode64`
  instead of `Base64.encode64` to avoid trailing newlines in image data.

### Testing
- Adjusted expected base64 size and checksum in `image_spec.rb` to
  reflect strict encoding output.
- Updated `message_spec.rb` JSON expectation to remove the trailing
  newline from the image payload.

## 2025-11-30 v1.12.0

### Features
- Added the `-i` flag to `ollama_cli` to display the Ollama server version using the `ollama.version.version` method.
- Added the `-d` flag to `ollama_cli` to enable debug mode, replacing the previous `DEBUG` environment variable.
- Enabled environment variable configuration for `ollama_console` to support `OLLAMA_CLIENT`, `OLLAMA_MODEL`, and `OLLAMA_MODEL_OPTIONS`.
- Added documentation specifying that the `think` parameter in `Ollama::Commands::Chat` and `Ollama::Commands::Generate` accepts string values ("high", "medium", "low") in addition to boolean values.

### Improvements
- Refactored model options handling in `ollama_cli` to utilize `Ollama::Options.from_hash` or `Ollama::Options.new` for better type safety.
- Included the `Ollama::DTO` module in the `Client::Config` class to ensure consistent data handling and serialization behavior.
- Updated the `ollama_console` client initialization to use `Client.configure_with` for more flexible and consistent configuration management.
- Improved documentation formatting and clarity in the `dto.rb` file.

### Fixes
- Updated the default model fallback in `ollama_cli` to correctly use the `full?` method for environment variable evaluation, ensuring robust default handling.

## 2025-11-05 v1.11.0

### Features
- Replaced `tabulo` with `terminal-table` **version 3.0** for table
  rendering in `ollama_ps`, including migration of logic from `Tabulo::Table`
  to `Terminal::Table`.
- Added early return handling for the empty model list case in `ollama_ps`.

### Documentation
- Updated YARD documentation guidelines to specify using `@attr`, `@attr_reader`,
  and `@attr_writer` tags instead of `@return` for attribute accessors.

## 2025-10-28 v1.10.1

### Features
- Added the `ollama_ps` executable to the gem, enabling users to view
  running models.

## 2025-10-28 v1.10.0

### Features

- Added `bin/ollama_ps` utility script to display running models with
  detailed metrics.
- Added `nokogiri` as a runtime dependency for HTML parsing.

### Fixes

- Used safe navigation to prevent errors when extracting model names from
  HTML elements.
- Stripped whitespace from model hash values before printing to ensure
  clean output.

### Build & CI

- Added `tabulo` as a runtime dependency for formatted table output.
- Updated the gemspec file list to include `bin/ollama_ps`.

### Documentation

- Added comprehensive header documentation to the `bin/ollama_cli`,
  `bin/ollama_browse`, `bin/ollama_console`, and `bin/ollama_update`
  scripts.

## 2025-10-20 v1.9.0

### Features
- Added a `dimensions` parameter to
  `Ollama::Commands::Embed#initialize` to truncate output
  embeddings to the specified dimension.

### Testing
- Skip `Ollama::Handlers::Say` tests on non-macOS systems
  when the `say` command is not executable.

### Build & CI
- Added a GitHub Actions workflow to deploy static
  content to GitHub Pages.
- Updated CI configuration to use `rake spec` and enabled
  `fail_fast: true`.
- Added `openssl-dev` and `ghostscript` dependencies to the
  CI Docker image.
- Updated `gem_hadar` development dependency to **~> 2.8**.

### Documentation
- Added a link to the online API documentation in
  `README.md`.
- Updated the license link in `README.md`.
- Updated the comment style guideline for `initialize`
  methods in `.contexts/code_comment.rb`.

## 2025-09-13 v1.8.1

### Build & CI
- Added `.yardopts` to `package_ignore` in `Rakefile`.
- Updated `gem_hadar` development dependency from `~> 2.4` to `~> 2.6`.

## 2025-09-12 v1.8.0

### Build & CI
- Changed `tins` runtime dependency constraint from `~> 1.41` to `~> 1` in
  both `Rakefile` and `ollama-ruby.gemspec`.
- Updated `gem_hadar` development dependency constraint from `~> 2.2` to
  `~> 2.4` in `ollama-ruby.gemspec`.

## 2025-09-09 v1.7.0

### Breaking
- Raised the minimum required Ruby version from **3.0** to **3.1** in
  the `Rakefile` and `ollama-ruby.gemspec`.

### Build & CI
- Added `context_spook` as a development dependency in
  `ollama-ruby.gemspec`.
- Removed the `ruby:3.0-alpine` image configuration from
  `.all_images.yml`.
- Updated the Dockerfile to include `gem update --system` and
  modified `.all_images.yml` to run `bundle update` before
  installation.

## 2025-09-09 v1.6.1

### Features
- Added support for Ruby **3.1** and **3.0** Alpine images in
  `.all_images.yml`.

### Improvements
- Updated required Ruby version from **3.1** to **3.0** in `Rakefile` and
  `ollama-ruby.gemspec`.
- Modified `as_json` and `to_json` methods in `lib/ollama/dto.rb` and
  `lib/ollama/response.rb` to accept ignored arguments.
- Added documentation comments for ignored arguments in `as_json` methods.

### Build & CI
- Updated `gem_hadar` version requirement from **2.0** to **2.2** in
  `ollama-ruby.gemspec`.
- Added `bundler` to the gems installed in `.all_images.yml`.
- Commented out `context_spook` development dependency in `Rakefile`.

## 2025-08-18 v1.6.0

### Features
- Added `context_spook` gem as a development dependency for
  documentation management.
- Introduced context files in the `.contexts/` directory to document project
  structure and YARD conventions.
- Display the Ollama server version in bold and the base URL as a
  hyperlink in `bin/ollama_console` using `Term::ANSIColor`.
- Added usage documentation for the `ollama_browse` utility to `README.md`.

### Fixes
- Enhanced `parse_json` in `Ollama::Client` to log a warning message when
  a `JSON::ParserError` occurs, allowing execution to continue.

### Improvements
- Refactored `bin/ollama_cli` prompt interpolation to use
  `named_placeholders` and `named_placeholders_interpolate` methods.
- Added default value handling for missing prompt variables in
  `bin/ollama_cli`.
- Removed the default value `{ ?M => '{}' }` from the `?M` option in the
  `bin/ollama_cli` command line parser.
- Updated the `tins` runtime dependency from `~> 1.34` to `~> 1.41`.
- Replaced manual SimpleCov configuration in `spec/spec_helper.rb` with
  `GemHadar::SimpleCov.start`.

### Build & CI
- Updated the `gem_hadar` development dependency to **2.0**.
- Included `.contexts/` files in the gemspec file list.

### Testing
- Added a spec to verify that `Ollama::Client` handles invalid JSON input
  by issuing a warning and returning `nil`.
- Improved test isolation by resetting the `OLLAMA_URL` environment
  variable after client spec tests.
- Replaced `RSpec.describe` with `describe` across all spec files.
- Improved nil comparison syntax in tests by using `be nil` instead of
  `be_nil`.

### Documentation
- Added comprehensive YARD documentation comments to classes and methods in
  the `Ollama` library.

## 2025-07-21 v1.5.0

### Features
- Added `ollama_browse` to the list of executables in the `Rakefile`
  and `ollama-ruby.gemspec`.
- Added support for the `-c` option in the `ollama_cli` script to
  specify client configuration as JSON.
- Replaced direct client initialization in `ollama_cli` with the
  `configure_with` method for improved maintainability.

### Improvements
- Clarified in `ollama_cli` documentation that the `-s` and `-p`
  arguments expect plain text input.
- Clarified in `ollama_cli` documentation that the `-M` argument
  expects model options in JSON format.
- Reorganized `ollama_cli` usage instructions and updated `README.md`
  to improve clarity and readability.

### Documentation
- Updated `README.md` to document the new `-c` option and the
  `OLLAMA_CLIENT` environment variable.
- Updated `README.md` to reflect that system and user prompts are
  now plain text rather than file paths.

## 2025-07-17 v1.4.0

### Features
- Added `bin/ollama_browse` CLI script to display model tags and
  metadata from the Ollama library.
- Introduced `lib/ollama/json_loader.rb` with `load_from_json` to
  initialize objects from JSON files.
- Added `Ollama::Client::Config` class and `configure_with` method for
  initializing `Ollama::Client` instances from configuration objects.

### Improvements
- Enhanced `ollama_browse` output to include file size and context
  size details.

### Documentation
- Updated `README.md` with examples for basic usage and configuration
  object setup.

### Testing
- Expanded test coverage for JSON file parsing and configuration
  handling.

## 2025-07-06 v1.3.0

### Features
- Added a `stream:` option to the Markdown handler to control
  incremental output.

### Improvements
- Moved the `ChatStart` handler into the `Ollama::Handlers` module.
- Updated CLI handler resolution to support conditional initialization
  based on handler type.

## 2025-06-02 v1.2.1

### Features
- Added a `-T` flag to `bin/ollama_cli` to enable thinking mode
  generation.

## 2025-06-01 v1.2.0

### Features
- Added `tool_calls` parameter and `attr_reader` to the `Ollama::Message` class.
- Added `thinking` parameter and `attr_reader` to the `Ollama::Message` class.

### Testing
- Updated `Ollama::Message` specs to cover the new `thinking` attribute.

## 2025-06-01 v1.1.0

### Features
- Added a `think` option to the `chat` and `generate` commands.

### Build & CI
- Removed the `--full-index` flag from the `bundle install` command.

## 2025-04-15 v1.0.0

### Breaking
- Renamed the `name` parameter to `model` in the `Ollama::Commands::Pull`,
  `Ollama::Commands::Push`, `Ollama::Commands::Delete`,
  `Ollama::Commands::Show`, and `Ollama::Commands::Create` classes.
- Changed the `modelfile` parameter to `system` and `name` to `model` in
  `Ollama::Commands::Create`.
- Added new optional parameters `from`, `files`, `adapters`, `template`,
  `license`, `parameters`, and `messages` to `Ollama::Commands::Create`.

### Features
- Added support for creating models with new parameters in
  `Ollama::Commands::Create`.
- Added `as_hash` and `as_array` helper methods to `Ollama::DTO` to
  standardize data structure conversions.

### Improvements
- Updated the `ollama_update` script to use the new `model` parameter when
  invoking the `pull` command.
- Improved the `ollama_chat` command prompt formatting by adding a newline
  before the continue prompt.

### Documentation
- Updated `README.md` to reflect the new parameter names and usage examples
  for `create`, `delete`, `pull`, `push`, and `show` commands.

### Testing
- Updated unit tests for `Ollama::Commands::Create`, `Ollama::Commands::Push`,
  `Ollama::Commands::Delete`, `Ollama::Commands::Show`, and
  `Ollama::Commands::Pull` to use the new parameter names.

## 2025-02-17 v0.16.0

### Features
- Added `ChatStart` handler to the Ollama CLI for saving chat
  sessions and enabling continuation via `ollama_chat`.

### Build & CI
- Added `yaml-dev` to Docker image dependencies for gem installation.

## 2025-02-12 v0.15.0

### Features
- Added `version` command to display the Ollama server version.

### Documentation
- Updated `README.md` to document the new `version` command.
- Added link to the `ollama-chat` GitHub repository in `README.md`.

### Build & CI
- Removed obsolete `REDIS_URL` and `REDIS_EXPIRING_URL` exports from
  `.envrc`.

### Testing
- Added basic spec for `Ollama::Commands::Version` class.

## 2025-01-29 v0.14.1

### Build & CI
- Removed the `documentrix` runtime dependency from the Rakefile and
  `ollama-ruby.gemspec`.

## 2025-01-29 v0.14.0

### Breaking

- Removed the `ollama_chat` executable from the main gem.
- Removed `term-ansicolor`, `redis`, `mime-types`, `reverse_markdown`,
  `complex_config`, `search_ui`, `amatch`, `pdf-reader`, `logger`, `xdg`,
  and `rss` dependencies from the gemspec.
- Removed `Ollama::Utils` module files including `Fetcher`, `Chooser`,
  `FileArgument`, and `CacheFetcher`.

### Features

- Added `kramdown-ansi` dependency to the gemspec.
- Implemented `==` method for `Ollama::DTO` class.
- Added `/config` command to display current chat configuration in
  `ollama_chat.rb` with pager support.
- Added system prompt length display using bold formatting.
- Added CLI documentation for `ollama_cli` executable in README.

### Improvements

- Simplified System Prompt Changer logic in `ollama_chat.rb`.
- Inlined `get_file_argument` method into `ollama_cli` script.
- Updated usage information in `ollama_cli` to mention environment variables.
- Refactored `ollama_chat` section in README to remove detailed usage.

### Build & CI

- Added `ruby:3.4-alpine` to `.all_images.yml` image list.
- Removed unnecessary `gem update --system` and `gem install bundler`
  commands from `.all_images.yml`.
- Removed `docker-compose.yml`, `config/redis.conf`, and `corpus` from
  `.gitignore`.
- Removed `ollama_chat` executable from Rakefile.

### Testing

- Removed specs for `Ollama::Utils` modules including `cache_fetcher`,
  `fetcher`, and `file_argument`.
- Added equality tests for `Ollama::Message` in `message_spec.rb`.
- Removed test prompt from `spec/assets/prompt.txt`.

### Documentation

- Updated README with new `ollama_cli` documentation section.
- Updated code block language identifiers to `bash` in README.
- Added short paragraph about `ollama_chat` in README.

## 2024-12-07 v0.13.0

### Breaking
- Replaced the `Ollama::Documents` module and `Ollama::Utils::Tags`
  class with dependencies on the `documentrix` gem, requiring users to
  update their code to reference `Documentrix::Documents` and
  `Documentrix::Utils::Tags`.
- Removed runtime dependencies on `numo-narray`, `more_math`,
  `sqlite-vec`, and `sqlite3`, as these features have been moved to the
  `documentrix` gem.
- Updated the runtime dependency on `reverse_markdown` to **3.0**.

### Improvements
- Optimized the default document cache in `ollama_chat` to use
  `Documentrix::Documents::SQLiteCache` instead of
  `Documentrix::Documents::RedisBackedMemoryCache`.
- Updated documentation markup configuration to use markdown by adding
  `--markup markdown` to `.yardopts` and updating doc comments to use
  markdown syntax.

### Build & CI
- Added `documentrix` as a runtime dependency in the gemspec and
  Rakefile.
- Added `rss` as a runtime dependency in the gemspec and Rakefile.
- Added `kramdown` as a development dependency.
- Updated the bundle installation script in `.all_images.yml` to
  remove `Gemfile.lock` before installing dependencies for faster
  updates.

## 2024-11-27 v0.12.1

### Fixes
- Added handling in `ollama_chat` to display "List is empty."
  when the `$links` list is empty.

## 2024-11-26 v0.12.0

### Features
- Added a `/links` command to `ollama_chat` to display all
  URLs used during the current session.
- Added `/links clear` functionality to remove specific or all
  previously used links from the session list.
- Introduced a `SQLiteCache` implementation for document
  storage, utilizing the `sqlite3` and `sqlite-vec` gems.
- Added `clear_for_tags` and `find_records_for_tags` methods
  to `Ollama::Documents::Cache::SQLiteCache` to enable
  efficient tag-based record management.
- Added a `user_agent` option to `Ollama::Client` to allow
  customizing the User-Agent header sent in requests.
- Added a `debug` option to `SQLiteCache` to enable SQL
  query explanation output to STDERR for troubleshooting.
- Implemented system prompt pre-selection in `ollama_chat`
  using a `-s ?regex` argument to filter and select prompts
  from the configuration.
- Added a `return_immediately` option to
  `Ollama::Utils::Chooser.choose` to auto-select single
  entries without user interaction.

### Fixes
- Fixed `Ollama::Documents::Splitters::Semantic` to return
  sentences directly when the embeddings array size is less
  than 2, preventing errors with small datasets.
- Corrected the prefix handling in
  `Ollama::Documents::Cache::SQLiteCache#full_each` to use
  `%` instead of an empty string, ensuring all keys are
  iterated over.
- Fixed URL extraction logic for DuckDuckGo search results
  in `ollama_chat` to match the updated link format.
- Updated `Ollama::Utils::Tags` to strip leading `#`
  characters from tag names to ensure consistent deduplication
  and display.
- Refactored `Ollama::Documents::Cache::SQLiteCache#execute`
  to sanitize query whitespace only when debugging, avoiding
  unnecessary string manipulation in production.

### Improvements
- Refactored `Ollama::Documents` to include the
  `Ollama::Documents::Cache` module and moved cache logic
  into dedicated mixins for `find_records`, `clear`, and
  `tags`.
- Migrated `Ollama::Documents::Record` to inherit from
  `Ollama::Documents::Cache::Records::Record` and added
  default values for `text` and `norm` attributes.
- Updated `Ollama::Documents::Cache::SQLiteCache` to use
  `Ollama::Utils::Tags` consistently for handling tag
  filtering and clearing operations.
- Added constraints and primary keys to the SQLite `records`
  table schema to improve data integrity.
- Replaced the `DEBUG` environment variable check in
  `ollama_chat` with the `$config.debug` setting.
- Removed the collection list from the chat info output to
  reduce clutter.
- Updated `ollama_chat` to pass `database_filename` and
  `debug` settings to the document cache initialization.
- Improved `ollama_chat` configuration to automatically
  create the cache directory and define a default database
  path.

### Build & CI
- Added `sqlite3` and `sqlite-vec` as runtime dependencies.
- Bumped `all_images` development dependency to **0.6**.
- Updated the Docker CI script to use `bundle install
  --full-index` and `bundle update`.

### Testing
- Added a new spec suite for
  `Ollama::Documents::Cache::SQLiteCache` covering
  instantiation, data persistence, and clearing operations.
- Added specs for `convert_to_vector`, `clear_for_tags`,
  and tag retrieval in `SQLiteCache`.
- Added specs for `SQLiteCache` and `MemoryCache` to
  verify key handling with different prefixes.
- Added a spec for `Ollama::Utils::Tags` to verify handling
  of unique tags with leading `#` characters.
- Refactored existing cache specs to use a shared `prefix`
  variable and added tests for iterating over keys and
  values.

### Documentation
- Updated `README.md` to document the new `/links` command
  and improved the description of `ollama_console`.
- Added documentation comments for
  `Ollama::Utils::Chooser.choose`.

## 2024-11-20 v0.11.0

### Features
- Added `ignoring` option to the document policy in the `ollama_chat` script.
- Added `voice` and `interactive` options to the `Ollama::Handlers::Say` class.

### Improvements
- Refactored the `Ollama::Handlers::Say` class to reopen the output stream if it is closed.
- Fixed `FollowChat` initialization to correctly assign markdown and voice attributes.
- Updated `excon` dependency from **0.111** to **1.0**.
- Added `ostruct` as a runtime dependency.
- Removed `kramdown-parser-gfm` and `terminal-table` dependencies.
- Updated `kramdown-ansi` dependency to require version **0.0.1** or higher.

### Testing
- Added specs for the `Ollama::Handlers::Say` output stream reopening and interactive mode.

## 2024-10-31 v0.10.0

### Features
- Added support for `file://` protocol and local file patterns
  starting with `~`, `.`, or `/` in `parse_content`.
- Replaced internal Markdown parsing with the `kramdown-ansi` gem.

### Fixes
- Ensures local file paths in `parse_content` are prefixed with `./`
  when necessary and checks for file existence before fetching.
- Removes fragment identifiers (`#`) from file URLs and paths in
  `parse_content`.
- Updated import and summarize messages to use `to_s.inspect` for
  accurate representation of source content.
- Improved context injection for location data to explicitly mention
  time and location in `ollama_chat`.

### Improvements
- Moved vector math methods (`norm`, `cosine_similarity`) into
  `Ollama::Documents::Cache::Common`.
- Refactored `Ollama::Documents` to delegate vector operations to the
  cache implementation.

### Build & CI
- Added `kramdown-ansi` as a runtime dependency.
- Removed `ollama/utils/width.rb` and `ollama/utils/ansi_markdown.rb`
  in favor of external library functions.

### Testing
- Removed `spec/ollama/utils/width_spec.rb` and
  `spec/ollama/utils/ansi_markdown_spec.rb`.

### Documentation
- Added documentation for `collections`, `pre`, and `unpre` methods
  in `Ollama::Documents::Cache::Common`.

## 2024-10-21 v0.9.3

- No user-visible changes.

## 2024-10-20 v0.9.2

### Features
- Added `SourceParsing` module with a `parse_csv` method to handle
  CSV files.
- Added an `empty?` method to `Ollama::DTO` using `to_hash`.
- Display model and embedding model options in the `info` output.

### Improvements
- Refactored `parse_source` logic into the new `SourceParsing`
  module.
- Only show `collection_stats` if embedding is performed.
- Moved `include Tins::GO` to the top of the `ollama_chat` script.

### Fixes
- Updated the `version` method in `ollama_chat` to use
  `Ollama::VERSION`.

### Testing
- Added a spec for `Ollama::Utils::ColorizeTexts`.
- Added a test for expected output of `documents.tags`.
- Added a test case for empty `Ollama::Options`.

## 2024-10-19 v0.9.1

### Fixes
- Corrected string interpolation in `import_source` to use
  `#{}` instead of `%{}` for `source_content`.
- Explicitly converted URL to a string in `normalize_url` to
  satisfy `URI.decode_www_form_component` requirements.

### Improvements
- Added `normalize_url` method to `Ollama::Utils::Fetcher` to
  decode URI components, remove anchors, and escape special
  characters; `excon` now normalizes provided URLs.
- Moved Switch classes and `setup_switches` method into the
  `Switches` module.
- Moved `pull_model_unless_present` method before other methods
  in `bin/ollama_chat`.
- Removed top-level `Ollama` namespace references in
  `bin/ollama_chat` since constants are already included.

### Testing
- Added specs for `normalize_url` in `fetcher_spec.rb`.
- Updated existing fetcher specs to use normalized URLs and
  assert standard error output on failure.

## 2024-10-18 v0.9.0

### Features
- Added a `/document_policy` command to select a scan policy for
  document references in the `ollama_chat` client.
- Updated `embed_source`, `import_source`, and `summarize_source` methods
  to respect the configured document policy.

### Fixes
- Fixed the `/info` regular expression in `ollama_chat` to ensure it
  matches only the full command and not substrings.
- Fixed the incorrect library homepage URL in `README.md`.

### Improvements
- Improved the confirmation prompt for the `/clobber` command to
  explicitly mention clearing messages and the collection.
- Removed an unnecessary `puts` statement from the `Markdown` handler to
  reduce output noise.

### Build & CI
- Updated the `gem_hadar` development dependency to version **1.19**.

### Testing
- Refactored test suites to use `expect` instead of `allow` for more
  precise expectation assertions.

### Documentation
- Reorganized `README.md` chapters to improve the logical flow of
  executable and usage documentation.

## 2024-10-07 v0.8.0

### Features
- Add `batch_size` configuration option to `OllamaChatConfig` and update `Documents::add` to respect it.
- Display a list of available document collections in `collection_stats` output.
- Include document indices in embedding status messages for progress tracking.

### Fixes
- Suppress standard error output when listing available voices with the `say` command.
- Improve regular expressions for parsing local file paths in `ollama_chat`.
- Add error handling in `Utils::Fetcher.read` to report non-existent files to standard error.
- Prevent matching the hostname component in `file://` URLs during source parsing.

### Improvements
- Add `#Tags` count to the `collection_stats` output.
- Switch the Redis service in `docker-compose.yml` to the `valkey/valkey:7.2.7-alpine` image.

### Documentation
- Update `CHANGES.md` with the release notes for **0.8.0**.
- Reformat `CHANGES.md` to use consistent indentation for list items.

## 2024-10-03 v0.7.0

### Breaking
- Renamed `/collection clear [tag]|change` to `/collection (clear|change)`.
- Removed the `sorted_set` dependency.

### Features
- Added support for reading PostScript files by converting them to PDF
  via Ghostscript.
- Added a `/location` command to toggle location context in the chat
  session.
- Added a `prompt` parameter to the `choose` method in
  `Ollama::Utils::Chooser`.

### Fixes
- Fixed Redis cache logic to delete keys with an expiration time of less
  than 1 second.
- Corrected a typo in the `Ollama::Image#==` method.
- Updated the `ollama_update` script to handle and report errors
  gracefully.

### Improvements
- Refactored `Ollama::Utils::Tags` to track source information and
  support hyperlink generation.
- Updated `Ollama::Utils::Width` to extend `Term::ANSIColor` and improve
  text truncation logic.
- Refactored the collection chooser to include `[EXIT]` and `[ALL]`
  options and added a confirmation prompt before clearing.
- Updated the read buffer size for tempfile writes to **16KB**.
- Renamed `ContentType` to `HeaderExtension` in
  `Ollama::Utils::Fetcher`.
- Updated `Ollama::Utils::CacheFetcher` to respect `cache-control`
  headers for expiration.

### Build & CI
- Added `tins` (~**1.34**) as a runtime dependency.

### Testing
- Added tests for `Ollama::Utils::Width` methods `wrap` and `truncate`.
- Added tests for `Ollama::Utils::Tags` source tracking and output.
- Added a test case for `Ollama::Image` equality.
- Updated `Ollama::Utils::CacheFetcher` specs to reflect cache
  expiration changes.

### Documentation
- Updated `README.md` to reflect new commands and command-line options.

## 2024-09-30 v0.6.0

### Features
- Added `/system` command to `ollama chat` to change the system prompt.
- Added `/voice` command to toggle voice output or change the active voice.
- Added `/copy` command to copy the last response to the system clipboard.
- Added `/stream` command to toggle stream output in the chat interface.
- Added `-V` command-line option to display the version and quit.
- Added `Ollama::Utils::CacheFetcher` class to cache HTTP responses in
  Redis.
- Implemented system prompt selection via `-s ?` in `ollama chat`.
- Added `REDIS_EXPIRING_URL` environment variable support for expiring
  caches.

### Fixes
- Corrected error message in `ollama chat` to say "Cannot fetch source"
  instead of "Cannot add source".
- Updated missing model error message to clarify that the model is being
  pulled from remote.
- Fixed `parse_source` in `ollama chat` to handle `nil` content types as
  plaintext.
- Fixed `File.secure_write` call in `ollama_chat` to use string conversion
  for `default_path`.
- Updated `OllamaChatConfig` to use `XDG` for resolving the config home
  directory.
- Refined `Ollama::Utils::FileArgument` logic to return content directly
  when it is present, rather than checking for `full?`.

### Improvements
- Refactored `Ollama::Utils::Fetcher` to make instance methods private and
  expose class methods for `get`, `read`, and `execute`.
- Introduced `CheckSwitch`, `Switch`, and `CombinedSwitch` classes in
  `ollama chat` to improve state management for features like markdown,
  streaming, and embedding.
- Updated `Ollama::Documents` initializer to include a `debug` option for
  colorized input logging.
- Updated `Show_system_prompt` in `ollama chat` to use ANSI Markdown
  parsing.
- Modified `ollama chat` to handle images by duplicating the array before
  adding it to the message and clearing the original.

### Build & CI
- Downgraded `xdg` dependency from `~> 8.0` to `~> 7.0` in both `Rakefile`
  and `ollama-ruby.gemspec`.
- Updated Docker Compose configuration to bind Redis service to
  `127.0.0.1:9736`.

### Testing
- Added `cache_fetcher_spec.rb` to test `Ollama::Utils::CacheFetcher`
  functionality.
- Updated `fetcher_spec.rb` to use the `expose` method for accessing
  private instance methods.
- Added `tins/xt/expose` requirement to `spec_helper.rb` for testing
  support.

### Documentation
- Updated `README.md` to document the new `/voice`, `/copy`, `/system`, and
  `/stream` commands.
- Removed `-v` command-line switch documentation in favor of `-V` for
  version.

## 2024-09-26 v0.5.0

### Features
- Added stdin substitution and variable expansion to `ollama_cli`, supporting `%{stdin}` in prompts and the `-P` option for setting prompt variables.
- Introduced proxy support in the Ollama chat client by adding a `proxy` option to `OllamaChatConfig` and updating `http_options` to include proxy settings.
- Enabled embedding, importing, and summarizing sources in the Ollama chat script, with new commands for `/embed`, `/import`, and `/summarize`.
- Added a `combining_string` option to `Character` and `RecursiveCharacter` splitters to customize how text chunks are joined.
- Provided Redis cache expiration support in `RedisCache` with an `ex` option and a `ttl` method for key time-to-live retrieval.
- Added an `execute` method to `Ollama::Utils::Fetcher` to run shell commands and capture their output as a `Tempfile`.
- Implemented SSL peer verification control via an `ssl_no_verify` option in `OllamaChatConfig` and `Ollama::Utils::Fetcher`.

### Improvements
- Enhanced the `/list` chat command to accept an optional argument specifying the number of recent messages to display.
- Refactored the `OllamaChatConfig` web prompt to use templated variables for queries and results instead of hardcoded interpolation.
- Updated `RedisCache` and `RedisBackedMemoryCache` to accept an `object_class` parameter for flexible JSON deserialization.
- Optimized source embedding logic in the chat script with simplified case statements and early exit conditions.
- Refactored `file_argument.rb` for better readability and simplified conditional logic.

### Fixes
- Fixed the semantic splitter to use the `include_separator` option from `opts` rather than hardcoding it to `true`.

### Documentation
- Updated `README.md` to reflect new `ollama_chat` commands and functionality.

### Build & CI
- Added `logger` and `json` as runtime dependencies in the gemspec and Rakefile.
- Updated `tins/xt/hash_union` dependency for proxy support in the chat client.

## 2024-09-21 v0.4.0

### Features
- Added a `-E` option to `ollama_chat` to disable embeddings for the
  current chat session.
- Added a `-M` option to `ollama_chat` to load document embeddings into an
  empty `MemoryCache` for the current chat session.
- Added CSV parsing support to the `parse_source` method in `ollama_chat`.

### Fixes
- Ensured that `Ollama::Utils::Fetcher` yields a `StringIO` object instead
  of `nil` when a request fails.
- Updated `FollowChat` to safely handle missing evaluation counts by
  defaulting to 0, preventing display errors.

### Improvements
- Refactored the cache implementation into the `Ollama::Documents::Cache`
  namespace and introduced `Ollama::Documents::Cache::RedisBackedMemoryCache`.
- Added a `debug` option to `Ollama::Utils::Fetcher` to enable backtrace
  logging.
- Updated `ollama_chat` to preserve system messages when clearing history
  using the new `clear_messages` method.
- Renamed the `tags` method to `tags_set` in `Ollama::Documents::Record`.
- Improved error handling in `Ollama::Utils::Fetcher` to handle missing
  status lines.

### Build & CI
- Added `debug` and `simplecov` as development dependencies.
- Added `doc` to the `.gitignore` and `Rakefile` ignore patterns.

### Documentation
- Added comments to the `ColorizeTexts` utility class.
- Added a comment to the `get_file_argument` method in `FileArgument`.
- Updated the `README.md` to document the new `-E` and `-M` options.

## 2024-09-15 v0.3.2

### Features
- Added ANSI color support to the `Ollama::Utils::Chooser` module, applying `blue`
  and `on_blue` styles to selected items.
- Updated the `summarize` method in `ollama_chat` to call
  `import_document` after parsing the source content.
- Refactored `Ollama::Utils::FileArgument#get_file_argument` to rename the
  `prompt` parameter to `path_or_content`.
- Made the `n` parameter in `search_web` optional, defaulting to 1 if
  omitted or less than 1.
- Implemented immediate exit with a "Goodbye" message when `nil` input is
  received in the `ollama_chat` command loop.

### Improvements
- Refactored tag list initialization and merging in `Ollama::Utils::Tags`
  specs to use array literals.

### Testing
- Added `file_argument_spec.rb` to test `Ollama::Utils::FileArgument`
  behavior, including a new `prompt.txt` asset.

### Build & CI
- Removed the `utils` development dependency from the Rakefile and gemspec.
- Removed `.utilsrc` from the ignored files list in the Rakefile.

## 2024-09-12 v0.3.1

### Features
- Add `/clobber` command to clear conversation messages and the
  document collection.
- Update `/web` command to summarize imported sources in addition
  to adding them to the collection.

### Improvements
- Refactor `eval_stats` in `FollowChat` to display evaluation and
  prompt evaluation rates in bold.
- Display chat help for any unknown command beginning with `/`.
- Use `prompts.summarize` configuration for generating summaries
  instead of a hardcoded string.
- Change `OllamaChatConfig` to use `prompts.system` instead of
  `system` for the system prompt.
- Display configuration using the default `to_s` tree
  representation.
- Fix `import_document` and `add_image` to handle nil `source_io`
  values.
- Update `Utils::Width` to use `uncolor` when checking line
  length.

### Build & CI
- Update `complex_config` dependency to `~> 0.22`.
- Update `infobar` dependency to `~> 0.8`.

## 2024-09-06 v0.3.0

### Features
- Added the `ollama_cli` executable to the gem for interacting
  with the Ollama API.
- Added support for parsing RSS and Atom feeds, including adding
  links to titles in item summaries.
- Added PDF parsing support to `ollama_chat` using the
  `pdf-reader` gem.
- Added a `/web [n] query` command to the chat interface for
  searching the web.
- Added a `find_where` method to `Ollama::Documents` to filter
  records by text size and count.
- Added a `found_texts_count` option to `OllamaChatConfig`.
- Updated `ollama_console` to provide an `ollama` method that
  returns a cached client instance.

### Improvements
- Extracted file argument handling into the
  `Ollama::Utils::FileArgument` module.
- Refactored system prompt handling to allow passing the prompt
  directly as a string or as a file path.
- Updated `Ollama::Documents#clear` to accept an optional `tags`
  parameter for selective clearing.
- Overloaded `Ollama::Utils::Tags#to_a` to return an array of
  strings.
- Added a `truncate` method to `Ollama::Utils::Width` and used it
  to truncate tags in progress bar labels.
- Updated `parse_source` to handle various content types including
  HTML, XML, RSS, and Atom feeds.

### Fixes
- Relaxed strict mode for `RSS::Parser.parse` to prevent parsing
  errors.
- Added size checks for `system_prompt` file paths to prevent
  filesystem limit issues.
- Fixed `MemoryCache#unpre` to correctly remove the prefix.
- Fixed `RedisCache#[]` to handle `nil` values.

### Documentation
- Updated `README.md` and chat help text to document the new
  `/web` command and `/collection clear [tag]` syntax.
- Updated `CHANGES.md` with release notes.

### Build & CI
- Added `pdf-reader` as a runtime dependency.
- Added `bin/ollama_cli` to the executable list in the gemspec and
  Rakefile.

### Testing
- Added tests for `Ollama::Documents#find_where`.
- Added tests for `Ollama::Documents#clear` with tags.
- Added tests for `Ollama::Documents::RedisCache` prefix handling.

## 2024-09-03 v0.2.0

### Breaking
- Renamed `Ollama::DTO` class method `json_create` to `from_hash`.
- Removed `json_class` from JSON serialization output of DTO objects.
- Removed `-d` option from `ollama_chat` command for markdown display.

### Features
- Added `/web` command to fetch search results from DuckDuckGo.
- Added support for specifying a page number in the `/web` command.
- Added `Ollama::Options.[]` method for casting hashes to options.

### Fixes
- Fixed bug in parsing content type of source documents.
- Updated width calculation to ensure `length` is a positive integer.
- Updated `/summarize` command to handle cases where summarization fails.
- Corrected message pop logic to divide popped messages by two.

### Improvements
- Updated `FollowChat` class to display evaluation statistics.
- Used `infobar` for import document status messages.
- Added `.keep` file to the `tmp` directory.
- Updated `OllamaChatConfig` to use `EOT` for heredoc syntax.

### Build & CI
- Added `CHANGES.md` to gem package files.
- Updated gem version to **0.2.0**.

### Testing
- Removed `json_class` from expected JSON payloads in command specs.
- Added tests for `Ollama::Options` hash casting.
- Fixed typo in test description for options casting.

## 2024-08-30 v0.1.0

### Features
- Add `Ollama::Documents` class for managing document embeddings and
  retrieval.
- Implement `Ollama::Documents::MemoryCache` and
  `Ollama::Documents::RedisCache` for persistent or in-memory storage.
- Introduce `Ollama::Documents::Splitters::Character`,
  `Ollama::Documents::Splitters::RecursiveCharacter`, and
  `Ollama::Documents::Splitters::Semantic` to split text into chunks.
- Enhance `ollama_chat` to support document embeddings, web/file RAG, and
  multimodal image input via URL or file path.
- Add support for YAML-based configuration for the `ollama_chat` client.
- Introduce `Ollama::Utils::Fetcher` for retrieving and parsing web and
  file sources.
- Add `Ollama::Utils::Chooser` for interactive selection of models and
  collections.
- Add new chat commands: `/collection`, `/summarize`, `/model`,
  `/markdown`, and `/pop [n]`.
- Add `ollama_update` executable to pull and update registered Ollama
  models.
- Add `path` attribute to `Ollama::Image` and factory methods to track
  source file locations.

### Improvements
- Refactor `ollama_chat` to use `Ollama::Utils::Fetcher` and
  `Ollama::Utils::Chooser`.
- Update `Ollama::Handlers::Progress` to display status and progress
  updates using `infobar`.
- Move `excon` requirement from `Ollama::Client` to `Ollama` module.
- Rename client instance variable to `ollama` in `ollama_console`.
- Update `ollama_chat` image handling to use arrays for multiple images.

### Fixes
- Refine regular expressions for `/pop`, `/save`, `/load`, and `/image`
  commands in `ollama_chat`.
- Fix `ollama_update` to avoid redundant module inclusion.

### Build & CI
- Add `redis`, `numo-narray`, `more_math`, `sorted_set`, `mime-types`,
  `reverse_markdown`, `complex_config`, `search_ui`, and `amatch` as
  runtime dependencies.
- Add `webmock` as a development dependency.
- Update `gem_hadar` development dependency to `~> 1.17.0`.
- Add Redis service to `docker-compose.yml` and `config/redis.conf`.
- Add `.envrc` to set `REDIS_URL` environment variable.

### Testing
- Add RSpec tests for `Ollama::Documents` and its cache implementations.
- Add RSpec tests for `Ollama::Documents::Splitters::Character` and
  `Ollama::Documents::Splitters::Semantic`.
- Add RSpec tests for `Ollama::Utils::Fetcher` and `Ollama::Utils::Tags`.
- Update `Ollama::Handlers::Progress` spec to use `infobar`.
- Add test for tracking image file paths in `Ollama::Image` spec.

### Documentation
- Update `README.md` with new `ollama_chat` options and configuration
  details.
- Add documentation for YAML config file structure and RAG setup.

## 2024-08-16 v0.0.1

### Features
- Added support for the `options` parameter in the `Embed` command to
  allow passing model-specific settings to the `/api/embed` endpoint.

### Improvements
- Updated the `README.md` example to use `.lazy.map` for streaming and
  renamed the client variable to `ollama` for consistency.

### Documentation
- Added documentation link for the `/api/embed` endpoint and marked the
  `embeddings` endpoint as superseded in `Ollama::Client::Doc`.

### Testing
- Renamed `client` to `ollama` in client and command specs for
  clarity and consistency.
- Updated `embed_spec` to verify the serialization of the new `options`
  parameter.

## 2024-08-12 v0.0.0

  * Start
