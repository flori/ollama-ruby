context do
  namespace "lib" do
    Dir['lib/**/*.rb'].each do |filename|
      file filename, tags: 'lib'
    end
  end

  namespace "spec" do
    Dir['spec/**/*.rb'].each do |filename|
      file filename, tags: 'spec'
    end
  end

  file 'README.md', tags: 'documentation'

  file '.contexts/yard.md', tags: [ 'yard', 'cheatsheet' ]

  meta guidelins: <<~EOT
    # Guidelines for creating YARD documentation

    - Look into the file, with tags yard and cheatsheet for how comment ruby
      constructs.
    - In comments above initialize methods **ALWAYS** omit @return
  EOT
end
