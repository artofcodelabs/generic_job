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
      @init_args = args
      self
    end

    private

      def receiver_has_method? name
        if @init_args
          @receiver.new(*@init_args).respond_to? name
        else
          @receiver.respond_to? name
        end
      end

      def call_missing_method name, *args
        if @init_args
          initialize_and_call_missing_method name, *args
        else
          call_missing_instance_method name, *args
        end
      end

      def call_missing_instance_method name, *args
        if args.any?
          GenericJob.set(@opts).perform_later @receiver, meth: name, args: args
        else
          GenericJob.set(@opts).perform_later @receiver, name
        end
      end

      def initialize_and_call_missing_method name, *args
        gj_args = {
          class: @receiver.name,
          init_args: @init_args,
          meth_args: args
        }
        GenericJob.set(@opts).perform_later gj_args, name
      end
  end
end
