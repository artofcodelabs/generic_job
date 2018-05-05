# frozen_string_literal: true

require 'test_helper'

class GenericJob::Test < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "async model's instance method call" do
    GenericJob.set(queue: :default)
              .perform_now users(:joe_doe), 'fetch_twitter!'
    assert_equal '@joe_doe', users(:joe_doe).twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test "async model's instance method call using higher lvl syntax" do
    perform_enqueued_jobs do
      users(:joe_doe).async(queue: :default).fetch_twitter!
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test "async PORO's instance method call" do
    args = {
      class: 'TwitterFetcher',
      init_args: { user_id: users(:joe_doe).id }
    }
    GenericJob.set(queue: :default).perform_now args, 'fetch'
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test "async model's instance method call with an argument" do
    GenericJob.set(queue: :default)
              .perform_now users(:joe_doe), meth: 'fetch_twitter!',
                                            arg: { only_name: true }
    assert_equal '@joe_doe', users(:joe_doe).twitter
    assert_nil users(:joe_doe).email
  end

  test "async PORO's instance method call with an argument" do
    args = {
      class: 'TwitterFetcher',
      init_args: { user_id: users(:joe_doe).id },
      meth_args: { skip_email: true }
    }
    GenericJob.set(queue: :default).perform_now args, 'fetch'
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end
end
