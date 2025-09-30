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
    'yard'
  package_ignore '.all_images.yml', '.tool-versions', '.gitignore', 'VERSION',
    '.rspec', '.github', '.contexts', '.yardopts'
  readme      'README.md'

  executables << 'ollama_console' << 'ollama_update' << 'ollama_cli' << 'ollama_browse'

  github_workflows(
    'static.yml' => {}
  )

  required_ruby_version  '~> 3.1'

  dependency             'excon',                 '~> 1.0'
  dependency             'infobar',               '~> 0.8'
  dependency             'json',                  '~> 2.0'
  dependency             'tins',                  '~> 1'
  dependency             'term-ansicolor',        '~> 1.11'
  dependency             'kramdown-ansi',         '~> 0.0', '>= 0.0.1'
  dependency             'ostruct',               '~> 0.0'
  development_dependency 'all_images',            '~> 0.6'
  development_dependency 'rspec',                 '~> 3.2'
  development_dependency 'kramdown',              '~> 2.0'
  development_dependency 'webmock'
  development_dependency 'debug'
  development_dependency 'simplecov'
  development_dependency 'context_spook'

  licenses << 'MIT'

  clobber 'coverage'
end
