# frozen_string_literal: true

class User < ApplicationRecord
  include GenericJob::Async

  validates :full_name, presence: true

  def self.fetch_twitter_for_all! opts = {}
    all.each { |user| user.fetch_twitter! opts }
  end

  def fetch_twitter! opts = {}
    TwitterFetcher.new(resource: self).fetch(
      skip_email: opts[:only_name]
    )
  end
end
