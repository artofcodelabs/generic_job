# frozen_string_literal: true

require 'test_helper'

class GenericJob::HigherLevelPoroSyntaxTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'async instance method call' do
    perform_enqueued_jobs do
      TwitterFetcher.async(queue: :default)
                    .new(user_id: users(:joe_doe).id)
                    .fetch
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test 'async instance method call with an argument' do
    perform_enqueued_jobs do
      TwitterFetcher.async(queue: :default)
                    .new(user_id: users(:joe_doe).id)
                    .fetch skip_email: true
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end
end
