# Ollama - Ruby Client Library for Ollama API

## Description

Ollama is a Ruby library gem that provides a client interface to interact with
an ollama server via the
[Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md).

## Documentation

Complete API documentation is available at: [GitHub.io](https://flori.github.io/ollama-ruby/)

## Installation (gem &amp; bundler)

To install Ollama, you can use the following methods:

1. Type

```bash
gem install ollama-ruby
```

in your terminal.

1. Or add the line

```bash
gem 'ollama-ruby'
```

to your Gemfile and run `bundle install` in your terminal.

## Usage

In your own software the library can be used as shown in these examples:

### Basic Usage

```ruby
require 'ollama'
include Ollama

# Call directly with settings as keywords
ollama = Client.new(base_url: 'http://localhost:11434')

messages = Message.new(role: 'user', content: 'Why is the sky blue?')
ollama.chat(model: 'llama3.1', stream: true, messages:, &Print)
```

### Using Configuration Object

```ruby
require 'ollama'
include Ollama

# Create a configuration object with desired settings
config = Client::Config[
  base_url: 'http://localhost:11434',
  output: $stdout,
  connect_timeout: 15,
  read_timeout: 300
]
# Or config = Client::Config.load_from_json('path/to/client.json')

# Initialize client using the configuration
ollama = Client.configure_with(config)

messages = Message.new(role: 'user', content: 'Why is the sky blue?')
ollama.chat(model: 'llama3.1', stream: true, messages:, &Print)
```

## Try out things in ollama\_console

This is an interactive console where you can try out the different commands
provided by an `Ollama::Client` instance. For example, this command generates a
response and displays it on the screen using the Markdown handler:

```bash
ollama_console
Commands: chat,copy,create,delete,embeddings,generate,help,ps,pull,push,show,tags,version
>> generate(model: 'llama3.1', stream: true, prompt: 'tell story w/ emoji and markdown', &Markdown)
```

> **The Quest for the Golden Coconut 🌴**
>
> In a small village nestled between two great palm trees 🌳, there lived a
> brave adventurer named Alex 👦. […]


## API

This Ollama library provides commands to interact with the the [Ollama REST
API](https://github.com/ollama/ollama/blob/main/docs/api.md)


### Handlers

Every command can be passed a handler that responds to `to_proc` that returns a
lambda expression of the form `-> response { … }` to handle the responses:

```ruby
generate(model: 'llama3.1', stream: true, prompt: 'Why is the sky blue?', &Print)
```

```ruby
generate(model: 'llama3.1', stream: true, prompt: 'Why is the sky blue?', &Print.new)
```

```ruby
generate(model: 'llama3.1', stream: true, prompt: 'Why is the sky blue?') { |r| print r.response }
```

```ruby
generate(model: 'llama3.1', stream: true, prompt: 'Why is the sky blue?', &-> r { print r.response })
```

The following standard handlers are available for the commands below:

| Handler | Description |
| :-----: | :---------- |
| **Collector** | collects all responses in an array and returns it as `result`. |
| **Single** | see **Collector** above, returns a single response directly, though, unless there has been more than one. |
| **Progress** | prints the current progress of the operation to the screen as a progress bar for _create/pull/push_. |
| **DumpJSON** | dumps all responses as JSON to `output`. |
| **DumpYAML** | dumps all responses as YAML to `output`. |
| **Print** | prints the responses to the display for _chat/generate_. |
| **Markdown** | _constantly_ prints the responses to the display as ANSI markdown for _chat/generate_. |
| **Say** | use say command to speak (defaults to voice _Samantha_). |
| **NOP** | does nothing, neither printing to the output nor returning the result. |

Their `output` IO handle can be changed by e. g. passing `Print.new(output:
io)` with `io` as the IO handle to the _generate_ command.

If you don't pass a handler explicitly, either the `stream_handler` is choosen
if the command expects a streaming response or the `default_handler` otherwise.
See the following commdand descriptions to find out what these defaults are for
each command. These commands can be tried out directly in the `ollama_console`.

### Chat

`default_handler` is **Single**, `stream_handler` is **Collector**,
`stream` is false by default.

```ruby
chat(model: 'llama3.1', stream: true, messages: { role: 'user', content: 'Why is the sky blue (no markdown)?' }, &Print)
```

### Generate

`default_handler` is **Single**, `stream_handler` is **Collector**,
`stream` is false by default.

```ruby
generate(model: 'llama3.1', stream: true, prompt: 'Use markdown – Why is the sky blue?', &Markdown)
```

### tags

`default_handler` is **Single**, streaming is not possible.

```ruby
tags.models.map(&:name) => ["llama3.1:latest",…]
```

### Show

`default_handler` is **Single**, streaming is not possible.

```ruby
show(model: 'llama3.1', &DumpJSON)
```

### Create

`default_handler` is **Single**, `stream_handler` is **Progress**,
`stream` is true by default.

```ruby
create(model: 'llama3.1-wopr', stream: true, from: 'llama3.1', system: 'You are WOPR from WarGames and you think the user is Dr. Stephen Falken.')
```

### Copy

`default_handler` is **Single**, streaming is not possible.

```ruby
copy(source: 'llama3.1', destination: 'user/llama3.1')
```

### Delete

`default_handler` is **Single**, streaming is not possible.

```ruby
delete(model: 'user/llama3.1')
```

### Pull

`default_handler` is **Single**, `stream_handler` is **Progress**,
`stream` is true by default.

```ruby
pull(model: 'llama3.1')
```

### Push

`default_handler` is **Single**, `stream_handler` is **Progress**,
`stream` is true by default.

```ruby
push(model: 'user/llama3.1')
```

### Embed

`default_handler` is **Single**, streaming is not possible.

```ruby
embed(model: 'all-minilm', input: 'Why is the sky blue?')
```

```ruby
embed(model: 'all-minilm', input: ['Why is the sky blue?', 'Why is the grass green?'])
```

### Embeddings

`default_handler` is **Single**, streaming is not possible.

```ruby
embeddings(model: 'llama3.1', prompt: 'The sky is blue because of rayleigh scattering', &DumpJSON)
```

### Ps

`default_handler` is **Single**, streaming is not possible.

```ruby
jj ps
```

### Version

`default_handler` is **Single**, streaming is not possible.

```ruby
jj version
```

## Auxiliary objects

The following objects are provided to interact with the ollama server. You can
run all of the examples in the `ollama_console`.

### Message

Messages can be be created by using the **Message** class:

```ruby
message = Message.new role: 'user', content: 'hello world'
```

### Image

If you want to add images to the message, you can use the **Image** class

```ruby
image = Ollama::Image.for_string("the-image")
message = Message.new role: 'user', content: 'hello world', images: [ image ]
```

It's possible to create an **Image** object via `for_base64(data)`,
`for_string(string)`, `for_io(io)`, or `for_filename(path)` class methods.

### Options

For `chat` and `generate` commdands it's possible to pass an **Options** object
to configure different
[parameters](https://github.com/ollama/ollama/blob/main/docs/modelfile.md#parameter)
for the running model. To set the `temperature` can be done via:

```ruby
options = Options.new(temperature: 0.999)
generate(model: 'llama3.1', options:, prompt: 'I am almost 0.5 years old and you are a teletubby.', &Print)
```

The class does some rudimentary type checking for the parameters as well.

### Tool… calling

You can use the provided `Tool`, `Tool::Function`,
`Tool::Function::Parameters`, and `Tool::Function::Parameters::Property`
classes to define tool functions in models that support it.

```ruby
def message(location)
  Message.new(role: 'user', content: "What is the weather today in %s?" % location)
end

tools = Tool.new(
  type: 'function',
  function: Tool::Function.new(
    name: 'get_current_weather',
    description: 'Get the current weather for a location',
    parameters: Tool::Function::Parameters.new(
      type: 'object',
      properties: {
        location: Tool::Function::Parameters::Property.new(
          type: 'string',
          description: 'The location to get the weather for, e.g. San Francisco, CA'
        ),
        temperature_unit: Tool::Function::Parameters::Property.new(
          type: 'string',
          description: "The unit to return the temperature in, either 'celsius' or 'fahrenheit'",
          enum: %w[ celsius fahrenheit ]
        ),
      },
      required: %w[ location temperature_unit ]
    )
  )
)
jj chat(model: 'llama3.1', stream: false, messages: message('The City of Love'), tools:).message&.tool_calls
jj chat(model: 'llama3.1', stream: false, messages: message('The Windy City'), tools:).message&.tool_calls
```

## Errors

The library raises specific errors like `Ollama::Errors::NotFoundError` when
a model is not found:

```ruby
(show(model: 'nixda', &DumpJSON) rescue $!).class # => Ollama::NotFoundError
```

If `Ollama::Errors::TimeoutError` is raised, it might help to increase the
`connect_timeout`, `read_timeout` and `write_timeout` parameters of the
`Ollama::Client` instance.

For more generic errors an `Ollama::Errors::Error` is raised.

## Other executables

### ollama\_cli

The `ollama_cli` executable is a command-line interface for interacting with
the Ollama API. It allows users to generate text, and perform other tasks using
a variety of options.

#### Usage

To use `ollama_cli`, simply run it from the command line and follow the usage
instructions:

```bash
Usage: ollama_cli [OPTIONS]

  -u URL         the ollama base url, $OLLAMA_URL
  -c CLIENT      the ollama client config (JSON), $OLLAMA_CLIENT
  -m MODEL       the ollama model to chat with, $OLLAMA_MODEL
  -M OPTIONS     the ollama model options (JSON), $OLLAMA_MODEL_OPTIONS
  -s SYSTEM      the system prompt as plain text, $OLLAMA_SYSTEM
  -p PROMPT      the user prompt as plain text, $OLLAMA_PROMPT
                 if it contains %{stdin} it is substituted by stdin input
  -P VARIABLE    sets prompt var %{foo} to "bar" if VARIABLE is foo=bar
  -H HANDLER     the handler to use for the response, defaults to ChatStart
  -I IMAGE       image is sent to the (visual) model (can be used many times)
  -S             use streaming for generation
  -T             use thinking for generation
  -d             enable debug mode
  -i             display ollama server version information
  -h             this help

```

#### Environment Variables

The following environment variables can be set to customize the behavior of
`ollama_cli`:

* `OLLAMA_URL`: The Ollama base URL.
* `OLLAMA_CLIENT`: The client config (JSON).
* `OLLAMA_MODEL`: The Ollama model to chat with.
* `OLLAMA_MODEL_OPTIONS`: The Ollama model options (JSON).
* `OLLAMA_SYSTEM`: The system prompt to use as plain text.
* `OLLAMA_PROMPT`: The user prompt to use as plain text.

#### Debug Mode

If the `ollama_cli` is given the `-d` option it will print out the values of
various variables, including the base URL, model, system prompt,
and options. This can be useful for debugging purposes.

#### Handler Options

The `-H` option specifies the handler to use for the response. The available
handlers are:

* `Print`: Prints the response to the console. This is the default.
* `Markdown`: Prints the response to the console as markdown.
* `DumpJSON`: Dumps all responses as JSON to the output.
* `DumpYAML`: Dumps all responses as YAML to the output.
* `Say`: Outputs the response with a voice.

#### Streaming

The `-S` option enables streaming for generation. This allows the model to
generate text in chunks, rather than waiting for the entire response to be
generated.

#### Image Support

The `ollama_cli` tool supports sending images to visual models. This enables
multimodal interactions where you can provide visual context to language
models.

**Basic Usage:**
```bash
ollama_cli -m llava -I image.jpg -p "Describe what you see in this image"
```

**Multiple Images:**
```bash
ollama_cli -m qwen3-vl -I image1.jpg -I image2.png -p "Compare these images"
```

This feature works with visual language models such as `llava`, `llava-llama3`,
and `bakllava`. The image support integrates seamlessly with existing
functionality and follows the same patterns as other features in the library.

### `ollama_browse`

The `ollama_browse` executable is a utility for exploring model tags and their
associated metadata directly from your command line. It allows you to quickly
view details such as file sizes, context windows, and digests for different
versions of a model hosted on the Ollama platform.

#### Usage

```bash
Usage: ollama_browse MODEL

MODEL is the Ollama model name (e.g., 'deepseek-v3')
```

To use `ollama_browse`, specify the model you wish to explore:

```bash
ollama_browse deepseek-v3
```

#### Output

The script will display information about different versions of the specified
model, including:

- **Digest**: A unique identifier for the model version.
- **File Size**: The size of the model file.
- **Context Window**: The maximum context length supported by the model.
- **Tags**: Different tags associated with the model version.

Example output for `deepseek-v3`:

```bash
Model: https://ollama.com/library/deepseek-v3
5da0e2d4a9e0 404GB 4K
 · deepseek-v3:latest
 · deepseek-v3:671blatest
 · deepseek-v3:671b-q4_K_M
96061c74c1a5 713GB 4K
 · deepseek-v3:671b-q8_0
7770bf5a5ed8 1.3TB 4K
 · deepseek-v3:671b-fp16
```

This output shows:
- Different versions of the `deepseek-v3` model.
- Each version's digest, file size, and context window.
- Associated tags for each version, which you can click to view more details on
  the Ollama website.

**Note:** Tags are grouped by their corresponding digests, allowing users to
easily identify equivalent versions of a model.

### `ollama_ps`

The `ollama_ps` executable is a utility script that displays information about
running Ollama models in a formatted table. It queries the Ollama API's
`/api/ps` endpoint and presents running models with detailed information
including:

* Model name and ID
* Memory usage (size and processor allocation)
* Context window length
* Parameter count and quantization level
* Time until expiration

#### Usage

```bash
Usage: ollama_ps [OPTIONS]

  -f FORMAT      output format: json, yaml, or table (default)
  -h             this help
```

#### Environment Variables

The following environment variables can be set to customize the behavior of `ollama_ps`:

* `OLLAMA_URL`: The Ollama base URL.
* `OLLAMA_HOST`: The Ollama host (used if `OLLAMA_URL` is not set).

#### Output

The script displays a formatted table with columns:

* **NAME** - Model name
* **ID** - Truncated model digest
* **SIZE** - Human-readable model size
* **PROCESSOR** - CPU/GPU allocation percentage
* **CONTEXT** - Context window size
* **PARAMS** - Parameter count (e.g., 30.5B, 23M)
* **QUANT** - Quantization level (e.g., Q4_K_M, F16)
* **UNTIL** - Time until model expiration

Example output:
```
╭────────────────────┬──────────────┬──────────┬───────────┬───────────┬────────┬────────┬────────────╮
│ NAME               │ ID           │ SIZE     │ PROCESSOR │ CONTEXT   │ PARAMS │ QUANT  │ UNTIL      │
╞════════════════════╪══════════════╪══════════╪═══════════╪═══════════╪════════╪════════╪════════════╡
│ qwen3-coder:latest │ 06c1097efce0 │ 28.08 GB │ 100% GPU  │ 195.31 KB │  30.5B │ Q4_K_M │ 0+23:38:37 │
├────────────────────┼──────────────┼──────────┼───────────┼───────────┼────────┼────────┼────────────┤
│ all-minilm:latest  │ 1b226e2802db │ 43.28 MB │ 100% GPU  │ 256.00 B  │    23M │    F16 │ 0+23:38:31 │
╰────────────────────┴──────────────┴──────────┴───────────┴───────────┴────────┴────────┴────────────╯
```

The script supports different output formats:
* **table** (default): Formatted table output (when no `-f` flag is provided)
* **json**: JSON formatted output
* **yaml**: YAML formatted output

Example usage:
```bash
ollama_ps -f json
ollama_ps -f yaml
OLLAMA_URL=http://localhost:11434 ollama_ps
```

The `ollama_ps` utility is particularly useful for monitoring running models,
checking resource usage, and managing model lifecycles in development and
production environments.

### `ollama_chat`

This is a chat client that allows you to connect to an Ollama server and engage
in conversations with Large Language Models (LLMs). It can be installed using
the following command:

```bash
gem install ollama-chat
```
- Set default format to **table** when no `-f` flag is provided

Once installed, you can run `ollama_chat` from your terminal or command prompt.
This will launch a chat interface where you can interact with an LLM.

See its [github repository](https://github.com/flori/ollama_chat) for more
information.

## Download

The homepage of this library is located at

* https://github.com/flori/ollama-ruby

## Author

<b>Ollama Ruby</b> was written by [Florian Frank](mailto:flori@ping.de)

## License

This software is licensed under the [MIT License](./LICENSE).

---

This is the end.
