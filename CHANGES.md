# Changes

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
