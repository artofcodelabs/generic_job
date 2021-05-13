# frozen_string_literal: true

require 'test_helper'

class GenericJob
  class Test < ActiveSupport::TestCase
    test 'type' do
      assert_kind_of Class, GenericJob
    end
  end
end
