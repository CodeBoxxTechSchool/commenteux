$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "commenteux/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|

  s.name        = "commenteux"
  s.version     = Commenteux::VERSION
  s.authors     = ["Groupe Fungo inc."]
  s.email       = ["ssavoie@fungo.ca"]
  s.homepage    = "http://www.fungo.ca"
  s.summary     = "This is a mountable gem that add a presentation layer to act_as_commentable."
  s.description = "Mount this gem into your app to automatically have acces to CRUD screen for comments on any of your resources. Those screen will be insertted in your current app layout. You can alo call the routes of the gem with ajax passing a parent div where you want the response to ben inserted."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.3"
  s.add_dependency "rspec-rails"
  s.add_dependency "acts_as_commentable"
  s.add_dependency "simple_form"

end
