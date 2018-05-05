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

    def method_missing name, *args, &_block
      if receiver_has_method? name
        call_missing_method name.to_s, *args
      else
        super
      end
    end

    private

      def receiver_has_method? name
        @receiver.respond_to? name
      end

      def call_missing_method name, *args
        if args.any?
          GenericJob.set(@opts).perform_later @receiver, meth: name,
                                                         arg: args.first
        else
          GenericJob.set(@opts).perform_later @receiver, name
        end
      end
  end
end
