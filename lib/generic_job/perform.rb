# frozen_string_literal: true

class GenericJob
  module Perform
    def perform receiver, data
      case receiver
      when Hash
        handle_passed_hash receiver.symbolize_keys, data
      when String
        handle_passed_obj receiver.constantize, data
      else
        handle_passed_obj receiver, data
      end
    end

    private

      def fetch_receiver hash
        if hash[:init_args]
          hash[:class].constantize.new(**to_array(hash[:init_args]).first)
        else
          hash[:class].constantize
        end
      end

      def handle_passed_hash hash, meth
        if hash[:meth_args]
          fetch_receiver(hash).send meth, *to_array(hash[:meth_args])
        else
          fetch_receiver(hash).send meth
        end
      end

      def handle_passed_obj obj, data
        case data
        when String
          obj.send data
        when Hash
          args = data[:args] || [data[:arg]]
          obj.send data[:meth], *args
        end
      end

      def to_array args
        return args if args.is_a? Array
        [args]
      end
  end
end
