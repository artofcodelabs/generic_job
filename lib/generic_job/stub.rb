# frozen_string_literal: true

class GenericJob
  class Stub
    def initialize receiver, opts
      @receiver = receiver
      @opts = opts
    end

    def respond_to_missing? name, include_private
      receiver_has_method?(name) || super
    end

    def method_missing name, *_args, &_block
      if receiver_has_method? name
        GenericJob.set(@opts).perform_later @receiver, name.to_s
      else
        super
      end
    end

    private

      def receiver_has_method? name
        @receiver.respond_to? name
      end
  end
end
