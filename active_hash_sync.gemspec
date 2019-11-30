lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_hash_sync/version"

Gem::Specification.new do |spec|
  spec.name          = "active_hash_sync"
  spec.version       = ActiveHashSync::VERSION
  spec.authors       = ["Yukito Ito"]
  spec.email         = ["yukibukiyou@gmail.com"]

  spec.summary       = %q{Sync ActiveHash's data with real database}
  spec.description   = %q{Sync ActiveHash's data with real database for redash etc...}
  spec.homepage      = "https://github.com/ykpythemind/active_hash_sync"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ykpythemind/active_hash_sync"
  spec.metadata["changelog_uri"] = "https://github.com/ykpythemind/active_hash_sync"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'active_hash', '~> 2.3.0'
  spec.add_dependency 'activerecord', '~> 5.0'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "sqlite3"
end
