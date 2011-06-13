
# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
EventAlert::Application.initialize!

# Fixes Heroku's SEO problem (trailing slashes, duplicate content..)
#config.gem 'rack-rewrite', '~> 0.1.2'
#
#require 'rack-rewrite'
# config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
# r301 %r{^/(.*)/$}, '/$1'
#end
