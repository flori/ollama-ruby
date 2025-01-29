# Ollama - Ruby Client Library for Ollama API

## Description

Ollama is a Ruby library gem that provides a client interface to interact with
an ollama server via the
[Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md).

## Installation (gem &amp; bundler)

To install Ollama, you can use the following methods:

1. Type

```
gem install ollama-ruby
```

in your terminal.

1. Or add the line

```
gem 'ollama-ruby'
```

to your Gemfile and run `bundle install` in your terminal.

## Usage

In your own software the library can be used as shown in this example:

```ruby
require 'ollama'
include Ollama

ollama = Client.new(base_url: 'http://localhost:11434')
messages = Message.new(role: 'user', content: 'Why is the sky blue?')
ollama.chat(model: 'llama3.1', stream: true, messages:, &Print) # or
print ollama.chat(model: 'llama3.1', stream: true, messages:).lazy.map { |response|
  response.message.content
}
```

## Try out things in ollama\_console

This is an interactive console where you can try out the different commands
provided by an `Ollama::Client` instance. For example, this command generates a
response and displays it on the screen using the Markdown handler:

```
$ ollama_console
Commands: chat,copy,create,delete,embeddings,generate,help,ps,pull,push,show,tags
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
show(name: 'llama3.1', &DumpJSON)
```

### Create

`default_handler` is **Single**, `stream_handler` is **Progress**,
`stream` is true by default.

```ruby
modelfile=<<~end
  FROM llama3.1
  SYSTEM You are WOPR from WarGames and you think the user is Dr. Stephen Falken.
end

create(name: 'llama3.1-wopr', stream: true, modelfile:)
```

### Copy

`default_handler` is **Single**, streaming is not possible.

```ruby
copy(source: 'llama3.1', destination: 'user/llama3.1')
```

### Delete

`default_handler` is **Single**, streaming is not possible.

```ruby
delete(name: 'user/llama3.1')
```

### Pull

`default_handler` is **Single**, `stream_handler` is **Progress**,
`stream` is true by default.

```ruby
pull(name: 'llama3.1')
```

### Push

`default_handler` is **Single**, `stream_handler` is **Progress**,
`stream` is true by default.

```ruby
push(name: 'user/llama3.1')
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
(show(name: 'nixda', &DumpJSON) rescue $!).class # => Ollama::NotFoundError
```

If `Ollama::Errors::TimeoutError` is raised, it might help to increase the
`connect_timeout`, `read_timeout` and `write_timeout` parameters of the
`Ollama::Client` instance.

For more generic errors an `Ollama::Errors::Error` is raised.

## Other executables

### ollama\_chat

This is a chat client that allows you to connect to an Ollama server and engage
in conversations with Large Language Models (LLMs). It can be installed using
the following command:

```
gem install ollama-chat
```

Once installed, you can run `ollama_chat` from your terminal or command prompt.
This will launch a chat interface where you can interact with an LLM.

## Download

The homepage of this library is located at

* https://github.com/flori/ollama-ruby

## Author

<b>Ollama Ruby</b> was written by [Florian Frank](mailto:flori@ping.de)

## License

This software is licensed under the <i>MIT</i> license.

---

This is the end.
