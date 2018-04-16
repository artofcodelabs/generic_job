# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require_relative '../test/dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [
  File.expand_path('../test/dummy/db/migrate', __dir__)
]
require 'rails/test_help'

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path(
    'fixtures',
    __dir__
  )
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase
                                                 .fixture_path
  ActiveSupport::TestCase.fixtures :all
end

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new
