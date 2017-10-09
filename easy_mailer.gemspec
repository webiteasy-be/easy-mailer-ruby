# -*- encoding: utf-8 -*-


=begin
#in /var/log/apache2/error_log
App 28159 stderr: /Users/rjoie/.rvm/gems/ruby-2.2.5@openstadium/gems/bundler-1.15.4/lib/bundler/dsl.rb:551:in `parse_line_number_from_description'
App 28159 stderr: : invalid byte sequence in US-ASCII (ArgumentError)
App 28159 stderr: 	from /Users/rjoie/.rvm/gems/ruby-2.2.5@openstadium/gems/bundler-1.15.4/lib/bundler/dsl.rb:517:in `to_s'
App 28159 stderr: 	from /usr/local/Cellar/passenger/5.1.2/libexec/src/helper-scripts/rack-preloader.rb:40:in `to_s'
App 28159 stderr: 	from /usr/local/Cellar/passenger/5.1.2/libexec/src/helper-scripts/rack-preloader.rb:40:in `format_exception'
App 28159 stderr: 	from /usr/local/Cellar/passenger/5.1.2/libexec/src/helper-scripts/rack-preloader.rb:119:in `rescue in preload_app'
App 28159 stderr: 	from /usr/local/Cellar/passenger/5.1.2/libexec/src/helper-scripts/rack-preloader.rb:99:in `preload_app'
App 28159 stderr: 	from /usr/local/Cellar/passenger/5.1.2/libexec/src/helper-scripts/rack-preloader.rb:156:in `<module:App>'
App 28159 stderr: 	from /usr/local/Cellar/passenger/5.1.2/libexec/src/helper-scripts/rack-preloader.rb:30:in `<module:PhusionPassenger>'
App 28159 stderr: 	from /usr/local/Cellar/passenger/5.1.2/libexec/src/helper-scripts/rack-preloader.rb:29:in `<main>'
[ 2017-09-06 10:57:17.5209 48392/0x7000061d4000 age/Cor/App/Implementation.cpp:304 ]: Could not spawn process for application /Users/rjoie/Webiteasy/2017SPO/apps/spo-web: An error occurred while starting up the preloader.
  Error ID: e4f8eb6f
  Error details saved to: /tmp/passenger-error-POmoQi.html
  Message from application: none

# when puts description in dsl.rb:551
There was an error while loading `easy_mailer_t.gemspec`: /Users/rjoie/Webiteasy/2017SPO/apps/spo-web/easy_mailer_t/easy_mailer_t.gemspec:10: invalid multibyte char (US-ASCII)
/Users/rjoie/Webiteasy/2017SPO/apps/spo-web/easy_mailer_t/easy_mailer_t.gemspec:10: invalid multibyte char (US-ASCII)
/Users/rjoie/Webiteasy/2017SPO/apps/spo-web/easy_mailer_t/easy_mailer_t.gemspec:10: syntax error, unexpected end-of-input, expecting ']'
  s.authors     = ["Raphaël Joie"]
                           ^
=end

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "easy_mailer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "easy_mailer"
  s.version     = EasyMailer::VERSION
  s.authors     = ["Raphaël Joie"]
  s.email       = ["raphael.joie@webiteasy.be"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of EasyMailer."
  s.description = "TODO: Description of EasyMailer."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.0.0"

  s.required_ruby_version = '>= 2.0.0'
  s.add_development_dependency "sqlite3"
end
