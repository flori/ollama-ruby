context do
  variable project_name: Pathname.pwd.basename

  variable project_version: File.read('VERSION').chomp

  variable branch: `git rev-parse --abbrev-ref HEAD`.chomp

  namespace "structure" do
    command "tree", tags: %w[ project_structure ]
  end

  file 'Rakefile',  tags: 'gem_hadar'

  file 'README.md', tags: 'documentation'

  meta ruby: RUBY_DESCRIPTION
end
