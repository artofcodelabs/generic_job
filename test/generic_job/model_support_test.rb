# frozen_string_literal: true

require 'test_helper'

class GenericJob::ModelSupportTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'async instance method call' do
    perform_enqueued_jobs do
      GenericJob.set(queue: :default)
                .perform_later users(:joe_doe), 'fetch_twitter!'
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test 'async instance method call with an argument' do
    perform_enqueued_jobs do
      GenericJob.set(queue: :default)
                .perform_later users(:joe_doe), meth: 'fetch_twitter!',
                                                arg: { only_name: true }
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end

  test 'async instance method call with arguments' do
    perform_enqueued_jobs do
      GenericJob.set(queue: :default)
                .perform_later users(:joe_doe), meth: 'fetch_twitter!',
                                                args: [{ only_name: true }]
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end

  test 'async class method call' do
    perform_enqueued_jobs do
      GenericJob.set(queue: :default)
                .perform_later 'User', 'fetch_twitter_for_all!'
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test 'async class method call with arguments' do
    perform_enqueued_jobs do
      GenericJob.set(queue: :default)
                .perform_later 'User', meth: 'fetch_twitter_for_all!',
                                       args: [{ only_name: true }]
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end
end
