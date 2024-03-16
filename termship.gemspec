# frozen_string_literal: true

require_relative "lib/termship/version"

Gem::Specification.new do |spec|
  spec.name          = "termship"
  spec.version       = Termship::VERSION
  spec.authors       = ["João Soares"]
  spec.email         = ["jsoaresgeral@gmail.com"]

  spec.summary       = "A simple battleship game for the terminal using the curses library"
  spec.description   = "A simple battleship game for the terminal using the curses library. This is a simple implementation of the classic battleship game using the curses library to draw the game board and handle user input. The game is played on a 10x10 grid where the player and the computer each place 5 ships. The player and the computer take turns to guess the position of the ships and the first one to sink all the ships of the opponent wins the game. The game is played in the terminal and uses the curses library to draw the game board and handle user input."
  spec.homepage      = "https://github.com/jasoares/termship"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "unpublished"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'curses', '~> 1.2'
  spec.add_development_dependency 'pry', '~> 0.14'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
