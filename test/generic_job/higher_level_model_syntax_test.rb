# frozen_string_literal: true

require 'test_helper'

class GenericJob
  class HigherLevelModelSyntaxTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    test 'default queue' do
      assert_enqueued_with(queue: 'default') do
        users(:joe_doe).async.fetch_twitter!
      end
    end

    test 'setting up queue' do
      assert_enqueued_with(queue: 'low') do
        users(:joe_doe).async(queue: 'low').fetch_twitter!
      end
    end

    test 'async instance method call' do
      perform_enqueued_jobs do
        users(:joe_doe).async.fetch_twitter!
      end
      assert_equal '@joe_doe', users(:joe_doe).reload.twitter
      assert_equal 'joedoe@gmail.com', users(:joe_doe).email
    end

    test 'async instance method call with an argument' do
      perform_enqueued_jobs do
        users(:joe_doe).async.fetch_twitter! only_name: true
      end
      assert_equal '@joe_doe', users(:joe_doe).reload.twitter
      assert_nil users(:joe_doe).email
    end

    test 'async class method call' do
      perform_enqueued_jobs do
        User.async.fetch_twitter_for_all!
      end
      assert_equal '@joe_doe', users(:joe_doe).twitter
      assert_equal 'joedoe@gmail.com', users(:joe_doe).email
    end

    test 'async class method call with an argument' do
      perform_enqueued_jobs do
        User.async.fetch_twitter_for_all! only_name: true
      end
      assert_equal '@joe_doe', users(:joe_doe).reload.twitter
      assert_nil users(:joe_doe).email
    end
  end
end
