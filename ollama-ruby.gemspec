# -*- encoding: utf-8 -*-
# stub: ollama-ruby 0.15.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ollama-ruby".freeze
  s.version = "0.15.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Florian Frank".freeze]
  s.date = "2025-02-12"
  s.description = "Library that allows interacting with the Ollama API".freeze
  s.email = "flori@ping.de".freeze
  s.executables = ["ollama_console".freeze, "ollama_update".freeze, "ollama_cli".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "lib/ollama.rb".freeze, "lib/ollama/client.rb".freeze, "lib/ollama/client/command.rb".freeze, "lib/ollama/client/doc.rb".freeze, "lib/ollama/commands/chat.rb".freeze, "lib/ollama/commands/copy.rb".freeze, "lib/ollama/commands/create.rb".freeze, "lib/ollama/commands/delete.rb".freeze, "lib/ollama/commands/embed.rb".freeze, "lib/ollama/commands/embeddings.rb".freeze, "lib/ollama/commands/generate.rb".freeze, "lib/ollama/commands/ps.rb".freeze, "lib/ollama/commands/pull.rb".freeze, "lib/ollama/commands/push.rb".freeze, "lib/ollama/commands/show.rb".freeze, "lib/ollama/commands/tags.rb".freeze, "lib/ollama/commands/version.rb".freeze, "lib/ollama/dto.rb".freeze, "lib/ollama/errors.rb".freeze, "lib/ollama/handlers.rb".freeze, "lib/ollama/handlers/collector.rb".freeze, "lib/ollama/handlers/concern.rb".freeze, "lib/ollama/handlers/dump_json.rb".freeze, "lib/ollama/handlers/dump_yaml.rb".freeze, "lib/ollama/handlers/markdown.rb".freeze, "lib/ollama/handlers/nop.rb".freeze, "lib/ollama/handlers/print.rb".freeze, "lib/ollama/handlers/progress.rb".freeze, "lib/ollama/handlers/say.rb".freeze, "lib/ollama/handlers/single.rb".freeze, "lib/ollama/image.rb".freeze, "lib/ollama/message.rb".freeze, "lib/ollama/options.rb".freeze, "lib/ollama/response.rb".freeze, "lib/ollama/tool.rb".freeze, "lib/ollama/tool/function.rb".freeze, "lib/ollama/tool/function/parameters.rb".freeze, "lib/ollama/tool/function/parameters/property.rb".freeze, "lib/ollama/version.rb".freeze]
  s.files = [".yardopts".freeze, "CHANGES.md".freeze, "Gemfile".freeze, "LICENSE".freeze, "README.md".freeze, "Rakefile".freeze, "bin/ollama_cli".freeze, "bin/ollama_console".freeze, "bin/ollama_update".freeze, "lib/ollama.rb".freeze, "lib/ollama/client.rb".freeze, "lib/ollama/client/command.rb".freeze, "lib/ollama/client/doc.rb".freeze, "lib/ollama/commands/chat.rb".freeze, "lib/ollama/commands/copy.rb".freeze, "lib/ollama/commands/create.rb".freeze, "lib/ollama/commands/delete.rb".freeze, "lib/ollama/commands/embed.rb".freeze, "lib/ollama/commands/embeddings.rb".freeze, "lib/ollama/commands/generate.rb".freeze, "lib/ollama/commands/ps.rb".freeze, "lib/ollama/commands/pull.rb".freeze, "lib/ollama/commands/push.rb".freeze, "lib/ollama/commands/show.rb".freeze, "lib/ollama/commands/tags.rb".freeze, "lib/ollama/commands/version.rb".freeze, "lib/ollama/dto.rb".freeze, "lib/ollama/errors.rb".freeze, "lib/ollama/handlers.rb".freeze, "lib/ollama/handlers/collector.rb".freeze, "lib/ollama/handlers/concern.rb".freeze, "lib/ollama/handlers/dump_json.rb".freeze, "lib/ollama/handlers/dump_yaml.rb".freeze, "lib/ollama/handlers/markdown.rb".freeze, "lib/ollama/handlers/nop.rb".freeze, "lib/ollama/handlers/print.rb".freeze, "lib/ollama/handlers/progress.rb".freeze, "lib/ollama/handlers/say.rb".freeze, "lib/ollama/handlers/single.rb".freeze, "lib/ollama/image.rb".freeze, "lib/ollama/message.rb".freeze, "lib/ollama/options.rb".freeze, "lib/ollama/response.rb".freeze, "lib/ollama/tool.rb".freeze, "lib/ollama/tool/function.rb".freeze, "lib/ollama/tool/function/parameters.rb".freeze, "lib/ollama/tool/function/parameters/property.rb".freeze, "lib/ollama/version.rb".freeze, "ollama-ruby.gemspec".freeze, "spec/assets/kitten.jpg".freeze, "spec/ollama/client/doc_spec.rb".freeze, "spec/ollama/client_spec.rb".freeze, "spec/ollama/commands/chat_spec.rb".freeze, "spec/ollama/commands/copy_spec.rb".freeze, "spec/ollama/commands/create_spec.rb".freeze, "spec/ollama/commands/delete_spec.rb".freeze, "spec/ollama/commands/embed_spec.rb".freeze, "spec/ollama/commands/embeddings_spec.rb".freeze, "spec/ollama/commands/generate_spec.rb".freeze, "spec/ollama/commands/ps_spec.rb".freeze, "spec/ollama/commands/pull_spec.rb".freeze, "spec/ollama/commands/push_spec.rb".freeze, "spec/ollama/commands/show_spec.rb".freeze, "spec/ollama/commands/tags_spec.rb".freeze, "spec/ollama/commands/version_spec.rb".freeze, "spec/ollama/handlers/collector_spec.rb".freeze, "spec/ollama/handlers/dump_json_spec.rb".freeze, "spec/ollama/handlers/dump_yaml_spec.rb".freeze, "spec/ollama/handlers/markdown_spec.rb".freeze, "spec/ollama/handlers/nop_spec.rb".freeze, "spec/ollama/handlers/print_spec.rb".freeze, "spec/ollama/handlers/progress_spec.rb".freeze, "spec/ollama/handlers/say_spec.rb".freeze, "spec/ollama/handlers/single_spec.rb".freeze, "spec/ollama/image_spec.rb".freeze, "spec/ollama/message_spec.rb".freeze, "spec/ollama/options_spec.rb".freeze, "spec/ollama/tool_spec.rb".freeze, "spec/spec_helper.rb".freeze, "tmp/.keep".freeze]
  s.homepage = "https://github.com/flori/ollama-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "Ollama-ruby - Interacting with the Ollama API".freeze, "--main".freeze, "README.md".freeze]
  s.required_ruby_version = Gem::Requirement.new("~> 3.1".freeze)
  s.rubygems_version = "3.6.2".freeze
  s.summary = "Interacting with the Ollama API".freeze
  s.test_files = ["spec/ollama/client/doc_spec.rb".freeze, "spec/ollama/client_spec.rb".freeze, "spec/ollama/commands/chat_spec.rb".freeze, "spec/ollama/commands/copy_spec.rb".freeze, "spec/ollama/commands/create_spec.rb".freeze, "spec/ollama/commands/delete_spec.rb".freeze, "spec/ollama/commands/embed_spec.rb".freeze, "spec/ollama/commands/embeddings_spec.rb".freeze, "spec/ollama/commands/generate_spec.rb".freeze, "spec/ollama/commands/ps_spec.rb".freeze, "spec/ollama/commands/pull_spec.rb".freeze, "spec/ollama/commands/push_spec.rb".freeze, "spec/ollama/commands/show_spec.rb".freeze, "spec/ollama/commands/tags_spec.rb".freeze, "spec/ollama/commands/version_spec.rb".freeze, "spec/ollama/handlers/collector_spec.rb".freeze, "spec/ollama/handlers/dump_json_spec.rb".freeze, "spec/ollama/handlers/dump_yaml_spec.rb".freeze, "spec/ollama/handlers/markdown_spec.rb".freeze, "spec/ollama/handlers/nop_spec.rb".freeze, "spec/ollama/handlers/print_spec.rb".freeze, "spec/ollama/handlers/progress_spec.rb".freeze, "spec/ollama/handlers/say_spec.rb".freeze, "spec/ollama/handlers/single_spec.rb".freeze, "spec/ollama/image_spec.rb".freeze, "spec/ollama/message_spec.rb".freeze, "spec/ollama/options_spec.rb".freeze, "spec/ollama/tool_spec.rb".freeze, "spec/spec_helper.rb".freeze]

  s.specification_version = 4

  s.add_development_dependency(%q<gem_hadar>.freeze, ["~> 1.19".freeze])
  s.add_development_dependency(%q<all_images>.freeze, ["~> 0.6".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.2".freeze])
  s.add_development_dependency(%q<kramdown>.freeze, ["~> 2.0".freeze])
  s.add_development_dependency(%q<webmock>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<debug>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<excon>.freeze, ["~> 1.0".freeze])
  s.add_runtime_dependency(%q<infobar>.freeze, ["~> 0.8".freeze])
  s.add_runtime_dependency(%q<json>.freeze, ["~> 2.0".freeze])
  s.add_runtime_dependency(%q<tins>.freeze, ["~> 1.34".freeze])
  s.add_runtime_dependency(%q<term-ansicolor>.freeze, ["~> 1.11".freeze])
  s.add_runtime_dependency(%q<kramdown-ansi>.freeze, ["~> 0.0".freeze, ">= 0.0.1".freeze])
  s.add_runtime_dependency(%q<ostruct>.freeze, ["~> 0.0".freeze])
end
