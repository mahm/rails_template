require 'rails'
require 'bundler'
require 'net/http'
require 'net/https'
#
# Application Template
#
@app_name = app_name

def get_and_store(filepath)
  get "https://raw.github.com/mahm/rails_template/master/#{filepath}", filepath
end

puts "\n========================================================="
puts " MAHM RAILS 3 TEMPLATE"
puts "=========================================================\n"

#------------------------------------------------------------------------------
# Gemfile
#------------------------------------------------------------------------------
# for Heroku
gem 'pg'
gem 'unicorn'

# Assets
gem 'compass-rails'
gem 'zurui-sass-rails'
gem 'font-awesome-rails'

# Basics
gem 'haml-rails'
gem 'jbuilder', '~> 1.2'
gem 'rack-pjax'
gem 'bootstrap-sass', '~> 2.3.2.0'
gem 'rails_config'

# View Helpers
gem 'simple_form'

# Active Record
gem 'devise'
gem 'squeel'
gem 'active_attr'
gem 'default_value_for'

# for Development
gem_group :development do
  gem 'erb2haml'
  gem 'i18n_generators'
  gem 'quiet_assets'
  gem 'letter_opener'
end

gem_group :development, :test do
  gem 'capybara'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'heroku_san'
  gem 'pry'
  gem 'debugger'
  gem 'better_errors'
end

run 'bundle install'

remove_file 'public/index.html'

# Assets
remove_file 'app/assets/stylesheets/application.css'
get_and_store 'app/assets/stylesheets/application.css'
get_and_store 'app/assets/stylesheets/base.css.sass'

empty_directory 'app/assets/stylesheets/colors'
get_and_store 'app/assets/stylesheets/colors/_colorlovers.css.sass'
get_and_store 'app/assets/stylesheets/colors/_dom.css.sass'
get_and_store 'app/assets/stylesheets/colors/_rambaral.css.sass'

get_and_store 'app/assets/images/witewall_3.png'
empty_directory 'app/assets/images/ico'
get_and_store 'app/assets/images/ico/favicon.ico'

# Views
remove_file 'app/views/layouts/application.html.erb'
get_and_store 'app/views/layouts/application.html.haml'
get_and_store 'app/views/layouts/_flash.html.haml'
empty_directory 'app/views/home'
get_and_store 'app/views/home/index.html.haml'

# Controllers
empty_directory 'app/controllers'
get_and_store 'app/controllers/home_controller.rb'

# application.rb
initialize_on_precompile = <<EOS
    # Don't initialize on precompile
    config.assets.initialize_on_precompile = false
EOS
insert_into_file 'config/application.rb', initialize_on_precompile, after: "config.assets.version = '1.0'\n"

# routes.rb
insert_into_file 'config/routes.rb', "\n  root to: 'home#index'\n\n", after: "Application.routes.draw do\n"

# unicorn.rb
get_and_store 'config/unicorn.rb'

# application_helper.rb
application_name = <<EOS
  def application_name
    'mahm Rails Template'
  end
EOS
insert_into_file 'app/helpers/application_helper.rb', application_name, after: "module ApplicationHelper\n"

# Generate
remove_dir 'test'
generate 'rspec:install'
generate 'rails_config:install'
generate 'simple_form:install --bootstrap'

# Git
git :init
git :add => '.'
git :commit => '-am "Initial Commit"'

puts "\n========================================================="
puts " INSTALLATION COMPLATE!"
puts "=========================================================\n"
