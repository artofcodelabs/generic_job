# frozen_string_literal: true

class GenericJob < ActiveJob::Base
  def perform obj, meth
    unless obj.is_a? Hash
      handle_passed_obj obj, meth
      return
    end
    obj.symbolize_keys!
    if obj[:meth_args]
      init_obj(obj).send meth, obj[:meth_args]
    else
      init_obj(obj).send meth
    end
  end

  private

  def init_obj hash
    hash[:class].constantize.new hash[:init_args]
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
