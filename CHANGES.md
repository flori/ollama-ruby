# Changes

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
