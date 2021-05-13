# frozen_string_literal: true

class GenericJob
  module Async
    extend ActiveSupport::Concern

    class_methods do
      def async(opts = {})
        GenericJob::Stub.new self, opts
      end
    end

    def async(opts = {})
      GenericJob::Stub.new self, opts
    end
  end
end
