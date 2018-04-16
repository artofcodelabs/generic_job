# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'generic_job'
  s.version     = '0.1.0'
  s.authors     = ['Zbigniew Humeniuk']
  s.email       = ['hello@artofcode.co']
  s.homepage    = 'https://artofcode.co'
  s.summary     = 'Summary of GenericJob.'
  s.description = 'Description of GenericJob.'
  s.license     = 'MIT'

  s.files = Dir[
    '{lib}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails', '>= 5.0', '< 6.0'

  s.add_development_dependency 'sqlite3'
end
