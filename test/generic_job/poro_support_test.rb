# frozen_string_literal: true

require 'test_helper'

class GenericJob::PoroSupportTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'async instance method call' do
    args = {
      class: 'TwitterFetcher',
      init_args: { resource_id: users(:joe_doe).id }
    }
    perform_enqueued_jobs do
      GenericJob.set(queue: :default).perform_later args, 'fetch'
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test 'async instance method call with an argument' do
    args = {
      class: 'TwitterFetcher',
      init_args: { resource_id: users(:joe_doe).id },
      meth_args: { skip_email: true }
    }
    perform_enqueued_jobs do
      GenericJob.set(queue: :default).perform_later args, 'fetch'
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end

  test 'async instance method call with arguments' do
    args = {
      class: 'TwitterFetcher',
      init_args: { resource_id: users(:joe_doe).id },
      meth_args: [{ skip_email: true }]
    }
    perform_enqueued_jobs do
      GenericJob.set(queue: :default).perform_later args, 'fetch'
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end

  test 'initialize passing an array of arguments' do
    args = {
      class: 'TwitterFetcher',
      init_args: [{ resource_id: users(:joe_doe).id }],
      meth_args: [{ skip_email: true }]
    }
    perform_enqueued_jobs do
      GenericJob.set(queue: :default).perform_later args, 'fetch'
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end

  test 'async class method call' do
    args = {
      class: 'TwitterFetcher'
    }
    perform_enqueued_jobs do
      GenericJob.set(queue: :default).perform_later args, 'fetch_for_all'
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test 'async class method call with arguments' do
    args = {
      class: 'TwitterFetcher',
      meth_args: ['User', [users(:joe_doe).id], { skip_email: true }]
    }
    perform_enqueued_jobs do
      GenericJob.set(queue: :default).perform_later args, 'fetch_for_all'
    end
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_nil users(:joe_doe).email
  end
end
