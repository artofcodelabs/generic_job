# frozen_string_literal: true

class User < ApplicationRecord
  validates :full_name, presence: true

  def fetch_twitter!
    TwitterFetcher.new(user: self).fetch
  end
end
