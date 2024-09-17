# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'ollama-ruby'
  path_name   'ollama'
  module_type :module
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "https://github.com/flori/#{name}"
  summary     'Interacting with the Ollama API'
  description 'Library that allows interacting with the Ollama API'
  test_dir    'spec'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', '.AppleDouble', '.bundle',
    '.yardoc', 'doc', 'tags', 'errors.lst', 'cscope.out', 'coverage', 'tmp',
    'corpus'
  package_ignore '.all_images.yml', '.tool-versions', '.gitignore', 'VERSION',
     '.rspec', *Dir.glob('.github/**/*', File::FNM_DOTMATCH)
  readme      'README.md'

  executables << 'ollama_console' << 'ollama_chat' <<
    'ollama_update' << 'ollama_cli'

  required_ruby_version  '~> 3.1'

  dependency             'excon',                 '~> 0.111'
  dependency             'infobar',               '~> 0.8'
  dependency             'term-ansicolor',        '~> 1.11'
  dependency             'kramdown-parser-gfm',   '~> 1.1'
  dependency             'terminal-table',        '~> 3.0'
  dependency             'redis',                 '~> 5.0'
  dependency             'numo-narray',           '~> 0.9'
  dependency             'more_math',             '~> 1.1'
  dependency             'sorted_set',            '~> 1.0'
  dependency             'mime-types',            '~> 3.0'
  dependency             'reverse_markdown',      '~> 2.0'
  dependency             'complex_config',        '~> 0.22'
  dependency             'search_ui',             '~> 0.0'
  dependency             'amatch',                '~> 0.4.1'
  dependency             'pdf-reader',            '~> 2.0'
  development_dependency 'all_images',            '~> 0.4'
  development_dependency 'rspec',                 '~> 3.2'
  development_dependency 'webmock'
  development_dependency 'debug'
  development_dependency 'simplecov'

  licenses << 'MIT'

  clobber 'coverage'
end
