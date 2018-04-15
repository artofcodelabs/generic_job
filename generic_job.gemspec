# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'generic_job/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'generic_job'
  s.version     = GenericJob::VERSION
  s.authors     = ['Zbigniew Humeniuk']
  s.email       = ['hello@artofcode.co']
  s.homepage    = 'TODO'
  s.summary     = 'TODO: Summary of GenericJob.'
  s.description = 'TODO: Description of GenericJob.'
  s.license     = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails', '>= 5.0', '< 6.0'
end
