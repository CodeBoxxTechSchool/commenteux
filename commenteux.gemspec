$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "commenteux/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|

  s.name        = "commenteux"
  s.version     = Commenteux::VERSION
  s.authors     = ["Groupe Fungo inc."]
  s.email       = ["ssavoie@fungo.ca"]
  s.homepage    = "https://github.com/groupefungo/commenteux"
  s.summary     = "This is a mountable gem that add a presentation layer to acts_as_commentable."
  s.description = "Mount this gem into your app to automatically have access to screens that list and create comments on any of your resources that use acts_as_commentable.
Those screen will be inserted in your current app layout. You can call the routes of the gem with ajax passing a parent
div where you want the response to be inserted."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.3"
  s.add_dependency "rspec-rails"
  s.add_dependency "acts_as_commentable"
  s.add_dependency "simple_form"

end
