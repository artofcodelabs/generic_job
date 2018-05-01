# frozen_string_literal: true

class TwitterFetcher
  def initialize user: nil, user_id: nil
    @user = user
    @user ||= User.find user_id
  end

  def fetch opts = {}
    fetch_name
    fetch_email unless opts[:skip_email]
    @user.save!
  end

  private

    # simulation
    def fetch_name
      name = '@' + @user.full_name.downcase.split(' ').join('_')
      @user.twitter = name
    end

    # simulation
    def fetch_email
      email = @user.full_name.downcase.split(' ').join + '@gmail.com'
      @user.email = email
    end
end
