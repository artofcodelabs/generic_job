# frozen_string_literal: true

class GenericJob < ActiveJob::Base
end

require_relative 'generic_job/perform'
require_relative 'generic_job/stub'
require_relative 'generic_job/async'

class GenericJob
  include GenericJob::Perform
end
