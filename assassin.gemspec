## assassin.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "assassin"
  spec.version = "1.4.2"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "assassin"
  spec.description = "no zombies ever, not even on `exit!` or `kill -9`"
  spec.license = "Ruby"

  spec.files =
["LICENSE",
 "README.md",
 "Rakefile",
 "assassin.gemspec",
 "lib",
 "lib/assassin.rb",
 "test",
 "test/assassin_test.rb",
 "test/child.rb",
 "test/lib",
 "test/lib/testing.rb",
 "test/parent.rb"]

  spec.executables = []
  
  spec.require_path = "lib"

  spec.test_files = nil

  

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/assassin"
end
