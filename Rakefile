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
    '.yardoc', 'tags', 'errors.lst', 'cscope.out', 'coverage', 'tmp'
  package_ignore '.all_images.yml', '.tool-versions', '.gitignore', 'VERSION',
     '.utilsrc', '.rspec', *Dir.glob('.github/**/*', File::FNM_DOTMATCH)
  readme      'README.md'

  executables << 'ollama_console' << 'ollama_chat'

  required_ruby_version  '~> 3.1'

  dependency             'excon',                 '~> 0.111'
  dependency             'infobar',               '~> 0.7'
  dependency             'term-ansicolor',        '~> 1.11'
  dependency             'kramdown-parser-gfm',   '~> 1.1'
  dependency             'terminal-table',        '~> 3.0'
  development_dependency 'all_images',            '~>0.4'
  development_dependency 'rspec',                 '~>3.2'
  development_dependency 'utils'

  licenses << 'MIT'
end
