# frozen_string_literal: true

class TwitterFetcher
  include GenericJob::Async

  def self.fetch_for_all(class_name = 'User', ids = [], opts = {})
    klass = class_name.constantize
    records = ids.empty? ? klass.all : klass.find(ids)
    records.each { |record| new(resource: record).fetch opts }
  end

  def initialize(resource: nil, resource_id: nil, resource_class: 'User')
    @resource = resource
    @resource ||= resource_class.constantize.find resource_id
  end

  def fetch(opts = {})
    fetch_name
    fetch_email unless opts[:skip_email]
    @resource.save!
  end

  private

  # simulation
  def fetch_name
    name = "@#{@resource.full_name.downcase.split.join('_')}"
    @resource.twitter = name
  end

  # simulation
  def fetch_email
    email = "#{@resource.full_name.downcase.split.join}@gmail.com"
    @resource.email = email
  end
end
