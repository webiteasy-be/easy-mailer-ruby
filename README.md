# EasyMailer
Testing and deployment of a good mailing strategy can be a painful job when bootstrapping a Ruby (on Rails) project.
With EasyMailer, you get an interface a syntax to preview, send, track and manage subscriptions to your emails.



## Usage
EasyMailer comes in four independent modules : Previewer, Subscriber, Tracker and Viewer. 
They work perfectly together but can also be used independently.

**Previewer**

- [x] preview a message as you would do for a regular page 
- [x] test different parameters
- [x] send it manually to any testing address

**Subscriber**
- [x] provide a customisable interface for user to (un-)subscribe
- [x] write an un-subscription link in the mails
- [x] manage subscription and un-subscriptions
- [x] automatically cancel (bounce) message sent to un-subscribed addresses

**Tracker**
- [x] follow the lifecycle of the messages (delivery, openings, clicks, ...)
- [x] append your own UTM tags to the tracking

**Viewer**
- [x] keep a copy of all the messages you sent
- [ ] allow your recipient to open the mail in their browser

... and more

### with Rails
With Rails, EasyMailer automatically detect all your mailers and the prototypes (actions) they defines.

### without Rails
TODO

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'easy_mailer', git: 'https://github.com/webiteasy-be/easy-mailer-ruby.git', ref: 'b07851909368f2bd0e27bab54f3a7b6ec5890921'
```

And then execute:
```bash
$ bundle install
```

### Configuration
By default, Easy Mailer and all its sub-features are **not** enabled. To initialize it, you must call the 
`EasyMailer.setup` method
```
# config/initializers/easy_mailer.rb

# Enable EasyMailer
EasyMailer.setup do |config|

  # Enable and setup default options for Subscriber
  config.subscriber.setup do |subscriber_config|
    subscriber_config.adapter = :active_record
  end

  # Enable and setup default options for Tracker
  config.tracker.setup do |tracker_config|
    tracker_config.adapter = :active_record
  end

  # Enable and setup default options for Viewer
  config.viewer.setup do |viewer_config|
    viewer_config.adapter = :active_record
  end
end
```
See the full list of options and default values in the dummy test app 
[config file](https://github.com/webiteasy-be/easy-mailer-ruby/blob/master/test/dummy/config/initializers/easy_mailer.rb)

### Database
EasyMailer is designed to be able to use different storage systems.
For now, only ActiveRecords adapters are available and
there is no rake task to migrate these records. check https://github.com/webiteasy-be/easy-mailer-ruby/tree/master/test/dummy/db/migrate
to get migration files 

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
