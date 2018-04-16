# frozen_string_literal: true

require 'test_helper'

class GenericJob::Test < ActiveSupport::TestCase
  test "async calling model's method" do
    GenericJob.set(queue: :default)
              .perform_now users(:joe_doe), 'fetch_twitter!'
    assert_equal '@joe_doe', users(:joe_doe).twitter
  end
end
