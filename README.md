# GenericJob

## 🤔 Why you may need it?

GenericJob is a Rails plugin.  

Active Job does a great work when it comes to declaring jobs and making them run on a variety of queuing backends.  
To do so, you have to create a job in `app/jobs`, implement `perform` method and enqueue a job by calling `perform_later`.

But most often you just want to call a given model's or service object's method in the background.

There is an effort involved with that: 

1. You have to define another _job_ for every class or even a method that you want to run in the background. 
2. If the purpose of this `ApplicationJob` class is to only run a specific method in the background, it feels redundant.
3. On the other hand, if you decide to have an additional logic in the _Job_ class, you basically lock it down to work in the background process only.

There should be an easier way. And there is. But before looking at the details, let's form our manifesto.


### 📜 Manifesto

**Every method should be possible to run in the background with the minimal effort. Wherever it makes sense.**

_Controller's method running in the background does not make sense for example_ 😉


This is what GenericJob does. It creates a default _Job_ called `GenericJob` and delivers a module named `GenericJob::Async`.  
Include it in a given class to be able to run its methods in the background.

## 🎮 Usage

Let's assume that we have following model and "service" classes in the app.

```ruby
class User < ApplicationRecord
  include GenericJob::Async

  validates :full_name, presence: true

  def self.fetch_twitter_for_all! opts = {}
    find_each { |user| user.fetch_twitter! opts }
  end

  # This method stays in the model for the sake of convenience.
  # Remember that the optimal way when dealing with external services like Twitter API 
  # is to call methods like this *** in the background ***
  # to avoid hanging up other application requests
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
# in the DB with the all args passed. Before that the job is enqueued on the "low" queue
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

As you can see on the preceding examples - the usage of the `async` method is essential. This method calls `ActiveJob::Core`'s [**set** class method](http://api.rubyonrails.org/v5.0/classes/ActiveJob/Core/ClassMethods.html#method-i-set) under the hood, so you can pass to `async` method all the options that `set` supports. And remember - this is still an `ActiveJob`, so passed method attributes must have serialized type.

For more examples look inside the `test` directory.  
Both exemplary classes above are taken from the dummy test app inside.

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

## 📄 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 👨‍🏭 Author

Zbigniew Humeniuk from [Art of Code](http://artofcode.co)

## 👀 See also

If you want to make your life easier in the other areas of the web app development as well, I strongly recommend you to take a look at my other project called [Loco framework](https://github.com/locoframework) 🙂. It is even more powerful and makes a front-end <-> back-end communication a breeze (among other things).