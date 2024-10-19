# Changes

## 2024-10-19 v0.9.1

* Fixing string interpolation in `import_source` method:
  + Changed result to use `#{}` instead of `%{}` for string interpolation
* Move `pull_model_unless_present` method:
  + Moved the method before other methods
* Moved Switch classes and `setup_switches` method into Switches module:
  + Moved the classes and method into a new module
* Utils::Fetcher: Normalize URL in fetcher utility:
  + Added `normalize_url` method to class Ollama::Utils::Fetcher
  + Normalizes URL by decoding URI components, removing anchors, and escaping special characters
  + `excon` method now calls `normalize_url` on the provided URL
  + Added specs for `normalize_url` in `fetcher_spec.rb`
* Remove Ollama top level Namespace b/c we include it from `ollama_chat`: 
  + Removed the top-level namespace

## 2024-10-18 v0.9.0

* Add document policy chooser and modify embedding/importing/summarizing
  behavior:
  + Add `/document_policy` command to choose a scan policy for document
    references
  + Modify `embed_source`, `import_source`, and `summarize_source` methods to
    use the chosen document policy
  + Update `choose_model` method to set `$document_policy` based on
    configuration or chat command
* Fix regular expression in `ollama_chat` script:
  + Updated regular expression for `/info` to `/^/info$`
* Improve ask prompt to ask about clearing messages and collection.
* Update specs to use `expect` instead of `allow`
* Fix library homepage URL in README.md
* Refactor Markdown handler to remove unnecessary puts statement
* Reorder chapters in README.md a bit

## 2024-10-07 v0.8.0

* **Refactor source handling in Ollama chat**:
  + Update regular expression to match dot-dot, dot or tilde prefix for local files
  + Add error handling for non-existent files in `Utils::Fetcher.read`
  + Stop matching the "hostname" part in file:// URLs
* **Update voice list command to suppress errors**:
  + Changed `say` command in OllamaChatConfig to `-v ? 2>/dev/null`
* **Add 'List:' and list of collections to the collection stats output**
* **Update collection stats display**:
  + Added new stat: `#Tags` to `collection_stats` method in `ollama_chat.rb`
  + Displaying number of tags for the current document collection
* **Refactor embed_source function to include document count**:
  + Added `count` parameter to `embed_source` method
  + Updated `puts` statements in `embed_source` and main loop to display document counts
  + Incremented `count` variable in main loop to track total documents embedded
  + Passed `count:` keyword argument to `embed_source` method
* **Add config option for batch_size and update document adding logic**:
  + Added `batch_size` option to `OllamaChatConfig`
  + Updated `embed_source` method in `bin/ollama_chat` to use `batch_size` from `config`
  + Updated `add` method in `lib/ollama/documents.rb` to accept `batch_size` and default to 10
* **Update Redis image to valkey/valkey:7.2.7-alpine**:
  + Updated `image` in `docker-compose.yml` to `valkey/valkey:7.2.7-alpine`
* **Reformat CHANGES.md**

## 2024-10-03 v0.7.0

* **Refactor command line interface**
  + Moved case order
  + Renamed `/collection clear [tag]|change` to `/collection (clear|change)`
  + Improved help message, added /info
* **Update README.md** 
  + Update README.md to reflect changed/added commands
* **Add support for reading PostScript**
  + Extracted `pdf_read` method to read PDF files using `PDF::Reader`
  + Added `ps_read` method to read PostScript files by converting them to PDF with Ghostscript and using `pdf_read`.
  + Updated `parse_source` method to handle PostScript files
* **Update read buffer size for tempfile writes**
  + Updated `tmp.write` to use a larger buffer size (**16KB**) in IO.popen block.
* **Refactor Collection Chooser and usages**
  + Added confirmation prompt before clearing collection
  + Improved collection chooser with `[EXIT]` and `[ALL]` options
  + Added `ask?` method for user input
* **Add prompt to choose method**
  + Added `prompt` parameter to `choose` method in `Ollama::Utils::Chooser`
  + Modified output formatting for selected entry in `choose` method
  + Updated `choose` method to handle cases better where no entry was chosen
* **Fix Redis cache expiration logic**
  + Update `set` method to delete key expiration time is less than 1 second.
* **Update dependencies and add source tracking** 
  - Remove `sorted_set` dependency from Rakefile
  - Modify `Ollama::Documents` class to track source of tags
  - Update `Ollama::Utils::Tags` class to include source in tag output and add methods for tracking source
  - Update tests for `Ollama::Utils::Tags` class
* **Refactor width calculation and add tests for wrap and truncate methods.**
  + Extend `Term::ANSIColor` in `Ollama::Utils::Width`
  + Update `width` method to use ellipsis length when truncating text
  + Add tests for `wrap` and `truncate` methods with percentage and length arguments
* **Add attr_reader for data and update equality check**
  + Added `attr_reader :data` to Ollama::Image class
  + Updated `==` method in Ollama::Image class to use `other.data`
  + Added test case in `image_spec.rb` to verify equality of images

## 2024-09-30 v0.6.0

### Significant Changes

* **Added voice toggle and change functionality**:
  + Removed `-v` command line switch
  + Added new Switch class for voice output
  + Added new method `change_voice` to toggle or change voice output
  + Updated `info` method to display current voice output if enabled
  + Updated `display_chat_help` method to include /voice command
* **Added expiring cache support**:
  + Added `Ollama::Utils::CacheFetcher` class for caching HTTP responses
  + Modified `Ollama::Utils::Fetcher` to use the new cache class
  + Updated `ollama_chat` script to use the cache when fetching sources
  + Added specs for the new cache fetcher class
* **Added change system prompt feature**:
  + Added `/system` command to change system prompt
  + Implemented `set_system_prompt` and `change_system_prompt` methods in `bin/ollama_chat`
  + Updated help messages in `README.md`

### Other Changes

* **Updated dependencies**:
  + Updated version of `xdg` gem to **7.0**
  + Added `xdg` dependency to Rakefile
* **Refactored error handling**:
  + Warn message updated to include more context about the error
  + `warn` statement now mentions "while pulling model"
* **Updated chat commands and added clipboard functionality**:
  + Added `/copy` command to copy last response to clipboard
  + Implemented `copy_to_clipboard` method in `ollama_chat`
  + Updated chat help display to include new `/copy` command
* **Refactored Ollama::Utils::Fetcher**:
  + Made instance methods private and only exposed class methods
  + Added `expose` method to `Ollama::Utils::FetcherSpec` for testing
* **Added version command to ollama chat binary**:
  + Added `version` method to print Ollama version and exit
  + Updated `$opts` string in `ollama` script to include `-V` option for version command
  + Added call to `version` method when `-V` option is used
* **Updated system prompt display**:
  + Changed `Ollama::Utils::Width.wrap` to `Ollama::Utils::ANSIMarkdown.parse` in `show_system_prompt` method
* **Added system prompt configuration via search_ui for ? argument value**:
  + Added `show_system_prompt` method to print configured system prompt
  + Modified `info` method to include system prompt in output
  + Implemented option `-s ?` to choose or specify system prompt

## 2024-09-26 v0.5.0

### New Features

* Add stdin substitution and variable expansion to `ollama_cli`:
  + Added support for `%{stdin}` in prompts, substituting with actual input
  + Added `-P` option to set prompt variables from command line arguments
  + Added handling of multiple placeholders in prompts
* Add proxy support to Ollama chat client:
  + Add `tins/xt/hash_union` gem to dependencies
    + Update `OllamaChatConfig` with new `proxy` option
    + Modify `http_options` method to include proxy and SSL verify peer options
      based on config settings
* Refactor source embedding logic:
    + Simplified explicit case statement.
    + Added `inputs or return` to ensure early exit when splitting cannot be
      done
* Update Ollama chat script to embed, import or summarize sources:
    + Added `require 'tins/xt/full'`
    + Updated prompts in `OllamaChatConfig` to include embed prompt and
      summarize prompt with word count option
    + Modified `import_document` method to use `embed_source` instead of
      importing document as a whole
    + Added `embed_source` method to parse source content and add it to the
      conversation via embeddings
    + Updated `summarize` method to take an optional word count parameter
    + Added `toggle_markdown` method to toggle markdown output on/off
    + Added `show_embedding` method to display embedding status
    + Updated `choose_collection` method to include new collection option
    + Added `set_embedding` method to set embedding model and paused embedding
    + Updated `info` method to display current model, collection stats, and
      embedding status

### Improvements

* Improve conversation listing command:
    + Allow `list_conversation` method to take an optional argument for the
      number of messages to display
    + Added support for displaying a specific number of messages with `/list
      [n]`
* Update chat commands' quit functionality:
  + Moved `/quit` command to exit the program
* Refactor OllamaChatConfig web prompt:
    + Add `web` prompt to `OllamaChatConfig` class
    + Replace hardcoded content with variable `content`
    + Use `query` and `results` variables instead of interpolating strings
* Add Redis cache expiration support:
    + Added `ex` option to `initialize` method in
      `lib/ollama/documents/cache/redis_cache.rb`
    + Updated `[]=` method in `lib/ollama/documents/cache/redis_cache.rb` to
      use Redis expiration
    + Added `ttl` method in `lib/ollama/documents/cache/redis_cache.rb` to get
      key TTL
* Update Redis and Redis-backed memory cache to use `object_class` parameter:
    + Added `object_class` parameter to `RedisBackedMemoryCache` and
      `RedisCache` constructors
    + Updated tests in `redis_backed_memory_cache_spec.rb` and
      `redis_cache_spec.rb` to reflect new behavior

### Bug Fixes

* Update semantic splitter to use `include_separator` option from opts:
    + Added flexibility by allowing `include_separator` option to be passed in
      through opts
    + Updated `include_separator` parameter to use
      `opts.fetch(:include_separator, true)` instead of hardcoding value to
      True.

### Refactoring

* Refactor `file_argument.rb` for better readability:
  + Update conditionals in Ollama::Utils::FileArgument module
  + Simplify logic with improved variable usage
  + Remove unnecessary elsif statement
  + Use consistent indentation and spacing throughout the code
* Refactor Redis-backed memory cache:
    + Removed `pre` and `unpre` methods from `Ollama::Documents` use mixin
      instead.

### Documentation

* Update README.md to reflect changes in `ollama_chat` functionality.
  + Modified commands:
    - `/import source` to import the source's content
    - `/embed source` to embed the source's content
        - `/summarize [n] source` to summarize the source's content in n words
        - `/embedding` to toggle embedding paused or not
    - `/embed source` to embed the source's content

### Dependencies and Date Updates

* Update dependencies and date in gemspec:
    + Added `logger` (~> **1.0**) and `json` (~> **2.0**) as runtime
      dependencies to Rakefile and ollama-ruby.gemspec.
    + Updated date in ollama-ruby.gemspec from "2024-09-21" to "2024-09-22".
  + Added `require 'logger'` to lib/ollama.rb.

### Other Changes

* Add SSL no verify option to OllamaChatConfig and Utils::Fetcher:
  + Added `ssl_no_verify` option to OllamaChatConfig
  + Updated Utils::Fetcher to take an

## 2024-09-21 v0.4.0

### Change Log for **1.2.3**

#### New Features

* Added `-E` option to disable embeddings for this chat session.
* Added `-M` option to load document embeddings into (empty) MemoryCache for this chat session.
* Added CSV parsing support to `ollama_chat`.
* Improved error handling in `Ollama::Utils::Fetcher` methods.

#### Bug Fixes

* Handle case in `ollama_chat` where responses don't provide counts, display 0
  rates instead.

#### Refactoring and Improvements

* Updated eval count and rate display in FollowChat class.
* Refactor system prompt display and chunk listing in chat output.
* Refactor cache implementation to use Ollama::Documents::Cache::Common module.
* Improved system prompt formatting in `ollama_chat` script.
* Renamed `tags` method to `tags_set` in `Ollama::Documents::Record` class.

#### Documentation

* Added comments to ColorizeTexts utility class.

## 2024-09-15 v0.3.2

* Add color support to chooser module:
  + Include `Term::ANSIColor` in `Ollama::Utils::Chooser` module
    + Use `blue`, `on_blue` ANSI color for selected item in query method
* Refactor summarize method to also import sources:
  + Added `content` variable to store result of `parse_source`
  + Replaced `or return` with explicit assignment and return
  + Added calls to `source_io.rewind` and `import_document`
* Add new test for `file_argument_spec.rb`
* Refactor tag list initialization and merging:
  + Use array literals for initializing tags lists
  + Use array literals for passing to merge method
* Update dependencies and dates in Rakefile and gemspec:
  + Removed '.utilsrc' from ignored files in Rakefile
  + Updated date in `ollama-ruby.gemspec` to "2024-09-13"
  + Removed 'utils' development dependency from `ollama-ruby.gemspec`
* Refactor `search_web` method to allow n parameter to be optional and default
  to 1.

## 2024-09-12 v0.3.1

* Update dependencies and date in gemspec files:
  - Updated `complex_config` dependency to '~> 0.22'
* Refactor FollowChat#eval_stats to add bold eval rates
  * Improve formatting in eval_stats using bold and color for better
    readability.
  * Update import_document and add_image methods to handle nil values
    correctly.
  * Update width method in utils/width.rb to use uncolor when checking line
    length.
* Refactor eval stats output in FollowChat class
  - Add indentation to eval stats output for better readability
* FollowChat evaluation stats refactored
  - Removed hardcoded eval_stats hash and replaced with method call
    `eval_stats(response)`
  - Added new method `eval_stats(response)` to calculate evaluation statistics
    - Calculates eval duration, prompt eval duration, total duration, and load
      duration
    - Adds eval count, prompt eval count, eval rate, and prompt eval rate
* Use default to_s tree representation of config.
  * Update complex_config dependency to ~> 0.21, >= 0.21.1 in Rakefile
  * Update complex_config dependency to ~> 0.21, >= 0.21.1 in
    ollama-ruby.gemspec
* Update dependencies and configuration display
  * Update 'complex_config' dependency to '~> 0.21'
  * Change OllamaChatConfig to display configuration as a tree instead of yaml
* Improve /web search command
  * Update infobar dependency to ~> 0.8
  * Update /web command to summarize web sources as well as importing them
    directly
  * Add /clobber command to clear conversation messages and collection
* Refactor Ollama chat configuration and summary generation.
  * Update `OllamaChatConfig` to use `prompts.system` instead of `system`.
  * Introduce `prompts.summarize` config as template for generating abstract
    summaries.
  * Replace hardcoded summary generation with call to `prompts.summarize`.
  * Display /help for all unknown chat commands starting wit `/`

## 2024-09-05 v0.3.0

* **New Features**
  * Created new file `ollama_cli` with Ollama CLI functionality.
  * Added executable `ollama_cli` to s.executables in ollama-ruby.gemspec.
  * Added `find_where` method in `documents.rb` to filter records by text size
    and count.
  * Added test for `find_where` method in `documents_spec.rb`.
  * Features for `ollama_chat`
      * Added `found_texts_count` option to `OllamaChatConfig`.
      * Implemented `parse_rss` method for RSS feeds and `parse_atom` method
        for Atom feeds.
      * Added links to titles in RSS feed item summaries and Atom feed item
        summaries.
      * Updated `parse_source` method to handle different content types,
        including HTML, XML, and RSS/Atom feeds.
      * Added `/web [n] query` command to search web and return n or 1 results
        in chat interface.
* **Improvements**
  * Improved validation for system prompts
  * Extracted file argument handling into a separate module and method
  * Added default value for config or model system prompt
  * Improved input validation for `system_prompt` path
  * Updated collection clearing logic to accept optional tags parameter
  * Updated `Tags` class to overload `to_a` method for converting to array of
    strings

## 2024-09-03 v0.2.0

### Changes

* **Added Web Search Functionality to `ollama_chat`**
  + Added `/web` command to fetch search results from DuckDuckGo
  + Updated `/summarize` command to handle cases where summarization fails
  + Fix bug in parsing content type of source document
* **Refactored Options Class and Usage**
  + Renamed `options` variable to use `Options[]` method in ollama_chat script
  + Added `[](value)` method to Ollama::Options class for casting hashes
  + Updated options_spec.rb with tests for casting hashes and error handling
* **Refactored Web Search Command**
  + Added support for specifying a page number in `/web` command
  + Updated regular expression to match new format
  + Passed page number as an argument to `search_web` method
  + Updated content string to reference the query and sources correctly
* **DTO Class Changes**
  + Renamed `json_create` method to `from_hash` in Ollama::DTO class
  + Updated `as_json` method to remove now unnecessary hash creation
* **Message and Tool Spec Changes**
  + Removed `json_class` from JSON serialization in message_spec
  + Removed `json_class` from JSON serialization in tool_spec
* **Command Spec Changes**
  + Removed `json_class` from JSON serialization in various command specs (e.g. generate_spec, pull_spec, etc.)
* **Miscellaneous Changes**
  + Improved width calculation for text truncation
  + Updated FollowChat class to display evaluation statistics
  + Update OllamaChatConfig to use EOT instead of end for heredoc syntax
  + Add .keep file to tmp directory

## 2024-08-30 v0.1.0

### Change Log for New Version

#### Significant Changes

* **Document Splitting and Embedding Functionality**: Added `Ollama::Documents` class with methods for adding documents, checking existence, deleting documents, and finding similar documents.
  + Introduced two types of caches: `MemoryCache` and `RedisCache`
  + Implemented `SemanticSplitter` class to split text into sentences based on semantic similarity
* **Improved Ollama Chat Client**: Added support for document embeddings and web/file RAG
  + Allowed configuration per yaml file
  + Parse user input for URLs or files to send images to multimodal models
* **Redis Docker Service**: Set `REDIS_URL` environment variable to `redis://localhost:9736`
  + Added Redis service to `docker-compose.yml`
* **Status Display and Progress Updates**: Added infobar.label = response.status when available
  + Updated infobar with progress message on each call if total and completed are set
  + Display error message from response.error if present
* **Refactored Chat Commands**: Simplified regular expression patterns for `/pop`, `/save`, `/load`, and `/image` commands
  + Added whitespace to some command patterns for better readability

#### Other Changes

* Added `Character` and `RecursiveCharacter` splitter classes to split text into chunks based on character separators
* Added RSpec tests for the Ollama::Documents class(es)
* Updated dependencies and added new methods for calculating breakpoint thresholds and sentence embeddings
* Added 'ollama_update' to executables in Rakefile
* Started using webmock
* Refactored chooser and add fetcher specs
* Added tests for Ollama::Utils::Fetcher
* Update README.md

## 2024-08-16 v0.0.1

* **New Features**
  + Added missing options parameter to Embed command
  + Documented new `/api/embed` endpoint
* **Improvements**
  + Improved example in README.md
* **Code Refactoring**
  + Renamed `client` to `ollama` in client and command specs
  + Updated expectations to use `ollama` instead of `client`

## 2024-08-12 v0.0.0

  * Start
