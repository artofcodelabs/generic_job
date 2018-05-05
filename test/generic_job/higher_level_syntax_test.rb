# frozen_string_literal: true

require 'test_helper'

class GenericJob::HigherLvlSyntaxTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "async model's instance method call" do
    perform_enqueued_jobs do
      users(:joe_doe).async(queue: :default).fetch_twitter!
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end
end
