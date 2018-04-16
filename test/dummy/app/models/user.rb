# frozen_string_literal: true

class User < ApplicationRecord
  validates :full_name, presence: true

  def fetch_twitter!
    update twitter: '@' + full_name.downcase.split(' ').join('_')
  end
end
