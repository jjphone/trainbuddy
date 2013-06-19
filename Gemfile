source 'https://rubygems.org'

gem 'rails'
gem 'bootstrap-sass'
gem 'faker'
gem 'will_paginate'
gem 'bootstrap-will_paginate'



# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem "pg", "~> 0.15.0.pre.454"

gem 'annotate', group: :development

group :development, :test do
	gem 'rspec-rails'
	# auto testig tools
	gem 'guard-rspec'
	gem 'guard-spork'
	gem 'spork'
	gem 'factory_girl_rails'

end

# moved from assets group due to issue with heroku 
#  http://www.davidlowry.co.uk/400/activeadmin-on-heroku-rails-3-1/


# Gems used only for assets and not required
# in production environments by default.
group :assets do

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'sass-rails'
  gem 'bourbon'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.2.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'paperclip', "~> 3.0"

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :test do 
	gem 'capybara', '1.1.2'
	gem 'rb-inotify'
	gem 'libnotify'
	gem 'cucumber-rails', :require => false
	gem 'database_cleaner'
end

