# frozen_string_literal: true

require_relative 'boot'

%w[
  active_job/railtie
  active_record/railtie
].each do |railtie|
  require railtie
end

Bundler.require(*Rails.groups)
require 'generic_job'

module Dummy
  class Application < Rails::Application
    config.load_defaults 7.0
  end
end
