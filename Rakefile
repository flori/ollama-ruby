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
    'corpus', 'yard'
  package_ignore '.all_images.yml', '.tool-versions', '.gitignore', 'VERSION',
     '.rspec', *Dir.glob('.github/**/*', File::FNM_DOTMATCH)
  readme      'README.md'

  executables << 'ollama_console' << 'ollama_chat' <<
    'ollama_update' << 'ollama_cli'

  required_ruby_version  '~> 3.1'

  dependency             'excon',                 '~> 1.0'
  dependency             'infobar',               '~> 0.8'
  dependency             'term-ansicolor',        '~> 1.11'
  dependency             'redis',                 '~> 5.0'
  dependency             'mime-types',            '~> 3.0'
  dependency             'reverse_markdown',      '~> 3.0'
  dependency             'complex_config',        '~> 0.22', '>= 0.22.2'
  dependency             'search_ui',             '~> 0.0'
  dependency             'amatch',                '~> 0.4.1'
  dependency             'pdf-reader',            '~> 2.0'
  dependency             'logger',                '~> 1.0'
  dependency             'json',                  '~> 2.0'
  dependency             'xdg',                   '~> 7.0'
  dependency             'tins',                  '~> 1.34'
  dependency             'kramdown-ansi',         '~> 0.0', '>= 0.0.1'
  dependency             'ostruct',               '~> 0.0'
  dependency             'rss',                   '~> 0.3'
  dependency             'documentrix',           '~> 0.0'
  development_dependency 'all_images',            '~> 0.6'
  development_dependency 'rspec',                 '~> 3.2'
  development_dependency 'kramdown',              '~> 2.0'
  development_dependency 'webmock'
  development_dependency 'debug'
  development_dependency 'simplecov'

  licenses << 'MIT'

  clobber 'coverage'
end
