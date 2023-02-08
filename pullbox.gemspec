# frozen_string_literal: true

require_relative "lib/pullbox/version"

Gem::Specification.new do |spec|
  spec.name = "pullbox"
  spec.version = Pullbox::VERSION
  spec.authors = ["PuLLi"]
  spec.email = ["the@pulli.dev"]

  spec.summary = "Just a small toolbox for AppleScript, DEVONthink and MailMate"
  spec.description = "Enables you to write ruby code for AppleScript, DEVONthink and MailMate features."
  spec.homepage = "https://github.com/the-pulli/pullbox"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/the-pulli/pullbox"
  spec.metadata["changelog_uri"] = "https://github.com/the-pulli/pullbox/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "nokogiri", "~> 1.12"
  spec.add_dependency "plist", "~> 3.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
