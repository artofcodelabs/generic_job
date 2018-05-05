# frozen_string_literal: true

class GenericJob < ActiveJob::Base
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
      hash[:class].constantize.new hash[:init_args]
    end

    def handle_passed_hash hash, meth
      if hash[:meth_args]
        init_obj(hash).send meth, hash[:meth_args]
      else
        init_obj(hash).send meth
      end
    end

    def handle_passed_obj obj, data
      case data
      when String
        obj.send data
      when Hash
        obj.send data[:meth], data[:arg]
      end
    end
end

require 'generic_job/stub'
require 'generic_job/async'
