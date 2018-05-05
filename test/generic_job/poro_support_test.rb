# frozen_string_literal: true

require 'test_helper'

class GenericJob::PoroSupportTest < ActiveSupport::TestCase
  test 'async instance method call' do
    args = {
      class: 'TwitterFetcher',
      init_args: { user_id: users(:joe_doe).id }
    }
    GenericJob.set(queue: :default).perform_now args, 'fetch'
    assert_equal '@joe_doe', users(:joe_doe).reload.twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test 'async instance method call with an argument' do
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
