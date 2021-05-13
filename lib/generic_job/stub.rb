# frozen_string_literal: true

class GenericJob
  class Stub
    def initialize receiver, opts
      @receiver = receiver
      @opts = opts
      @init_args = nil
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

    def new *args
      @init_args = args.first
      self
    end

    private

      def receiver_has_method? name
        if @init_args
          @receiver.new(**@init_args).respond_to? name
        else
          @receiver.respond_to? name
        end
      end

      def call_missing_method name, *args
        if @init_args
          GenericJob.set(@opts).perform_later receiver_as_hash(args), name
        else
          GenericJob.set(@opts)
                    .perform_later prepare_receiver, meth: name, args: args
        end
      end

      def receiver_as_hash args
        {
          class: @receiver.name,
          init_args: @init_args,
          meth_args: args
        }
      end

      def prepare_receiver
        return @receiver unless @receiver.is_a? Class
        @receiver.name
      end
  end
end
