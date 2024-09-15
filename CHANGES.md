# Changes

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
