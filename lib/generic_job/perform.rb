# frozen_string_literal: true

class GenericJob
  module Perform
    def perform obj_or_hash, meth
      case obj_or_hash
      when Hash
        handle_passed_hash obj_or_hash.symbolize_keys, meth
      else
        handle_passed_obj obj_or_hash, meth
      end
    end

    private

      def init_obj hash
        hash[:class].constantize.new(*to_array(hash[:init_args]))
      end

      def handle_passed_hash hash, meth
        if hash[:meth_args]
          init_obj(hash).send meth, *to_array(hash[:meth_args])
        else
          init_obj(hash).send meth
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
