# frozen_string_literal: true

require 'test_helper'

class GenericJob::ModelSupportTest < ActiveSupport::TestCase
  test 'async instance method call' do
    GenericJob.set(queue: :default)
              .perform_now users(:joe_doe), 'fetch_twitter!'
    assert_equal '@joe_doe', users(:joe_doe).twitter
    assert_equal 'joedoe@gmail.com', users(:joe_doe).email
  end

  test 'async instance method call with an argument' do
    GenericJob.set(queue: :default)
              .perform_now users(:joe_doe), meth: 'fetch_twitter!',
                                            arg: { only_name: true }
    assert_equal '@joe_doe', users(:joe_doe).twitter
    assert_nil users(:joe_doe).email
  end
end
