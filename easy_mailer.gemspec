$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "easy_mailer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "easy_mailer"
  s.version     = EasyMailer::VERSION
  s.authors     = ["Raphaël Joie"]
  s.email       = ["raphael.joie@webiteasy.be"]
  s.homepage    = "https://github.com/webiteasy-be/easy-mailer-ruby"
  s.summary     = "Preview, track and keep every mails."
  s.description = "EasyMailer is an all-in-one administration panel for your emails on Ruby and Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.0.0"

  s.required_ruby_version = '>= 2.0.0'
  s.add_development_dependency "sqlite3"
end
