# GenericJob

GenericJob is a Rails plugin. Active Job does a great work when it comes to declaring jobs and making them run on a variety of queuing backends. But it would be nice to be able to very easily run a model's or PORO's instance or class method in the background without having to create another _job_.  
This is what GenericJob does. It creates a default _job_ called `GenericJob` and delivers a module named `GenericJob::Async` which you have to include to be able to run methods of the particular class in the background.

## 🎮 Usage

Let's assume that we have following model and "service" classes in our app.

```ruby
class User < ApplicationRecord
  include GenericJob::Async

  validates :full_name, presence: true

  def self.fetch_twitter_for_all! opts = {}
    find_each { |user| user.fetch_twitter! opts }
  end

  def fetch_twitter! opts = {}
    TwitterFetcher.new(resource: self).fetch(
      skip_email: opts[:only_name]
    )
  end
end

class TwitterFetcher
  include GenericJob::Async

  def self.fetch_for_all class_name = 'User', ids = [], opts = {}
    klass = class_name.constantize
    records = ids.empty? ? klass.all : klass.find(ids)
    records.each { |record| new(resource: record).fetch opts }
  end

  def initialize resource: nil, resource_id: nil, resource_class: 'User'
    @resource = resource
    @resource ||= resource_class.constantize.find resource_id
  end

  def fetch opts = {}
    fetch_name
    fetch_email unless opts[:skip_email]
    @resource.save!
  end

  private

    def fetch_name
      # implement!
    end

    def fetch_email
      # implement!
    end
end
```

All you need to do to be able to run methods in the background is to include `GenericJob::Async` in both classes.

Now you can do things like these:

```ruby
# this code calls the "fetch_twitter!" method in the background for the 1st User 
# in the DB and with the all passed args. The job is enqueued on the "low" queue before
User.first.async(queue: 'low')
          .fetch_twitter! only_name: true

# this line calls "fetch_twitter_for_all!" class method on a queuing backend
# with the passed args. The job is enqueued on the 'default' queue
User.async.fetch_twitter_for_all! only_name: true

# this code initializes an object in the background and then calls 
# the "fetch" method. Given arguments are passed to the constructor 
# and the "fetch" method accordingly
TwitterFetcher.async(queue: :default)
              .new(resource_id: 101)
              .fetch skip_email: true

# this line calls "fetch_for_all" class method on a queuing backend
# with the passed args through the "default" queue
TwitterFetcher.async.fetch_for_all 'User', [12, 13], skip_email: true
```

As you can see on the preceding examples - the usage of the `async` method is essential. This method calls `ActiveJob::Core`'s [**set** class method](http://api.rubyonrails.org/v5.0/classes/ActiveJob/Core/ClassMethods.html#method-i-set) under the hood, so you can pass to `async` method all the options that `set` supports.

For more examples look inside the `test` directory. Both exemplary classes above are taken from the dummy test app as well.

## 📥 Installation

Add this line to your application's Gemfile:

```ruby
gem 'generic_job'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install generic_job
```

## 📜 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 👨‍🏭 Author

Zbigniew Humeniuk from [Art of Code](http://artofcode.co)

## 👀 See also

If you want to make your life easier in the other areas of the web app development as well, I strongly recommend you to take a look at my other project called [Loco framework](https://github.com/locoframework) 🙂. It is even more powerful and makes a front-end <-> back-end communication a breeze (among other things).