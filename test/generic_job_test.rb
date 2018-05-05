# frozen_string_literal: true

require 'test_helper'

class GenericJob::Test < ActiveSupport::TestCase
  test 'type' do
    assert_kind_of Class, GenericJob
  end
end
