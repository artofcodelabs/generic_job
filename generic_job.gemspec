# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'generic_job'
  s.version     = '0.0.2'
  s.authors     = ['Zbigniew Humeniuk']
  s.email       = ['hello@artofcode.co']
  s.homepage    = 'https://artofcode.co'
  s.summary     = 'Higher level abstraction on the top of ActiveJob.'
  s.description = 'Run instance and class methods in the background jobs with ease.'
  s.license     = 'MIT'

  s.files = Dir[
    '{lib}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.required_ruby_version = '>= 2.6.0'

  s.add_dependency 'rails', '>= 5.0', '< 7.0'

  s.add_development_dependency 'rubocop', '~> 0.89'
  s.add_development_dependency 'rubocop-rails', '~> 2.7'
  s.add_development_dependency 'sqlite3', '~> 1.4.1'
end
