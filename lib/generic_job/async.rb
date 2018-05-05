# frozen_string_literal: true

class GenericJob
  module Async
    def async opts = {}
      GenericJob::Stub.new self, opts
    end
  end
end
