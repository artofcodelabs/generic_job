# frozen_string_literal: true

class User < ApplicationRecord
  include GenericJob::Async

  validates :full_name, presence: true

  def fetch_twitter! opts = {}
    TwitterFetcher.new(user: self).fetch(
      skip_email: opts[:only_name]
    )
  end
end
