require 'rails'
require 'bundler'
require 'net/http'
require 'net/https'
#
# Application Template
#
repo_url = 'https://raw.github.com/mahm/rails3_template/master'
gems = {}

@app_name = app_name

def get_and_gsub(source_path,  local_path)
  get source_path,  local_path

  gsub_file local_path,  /%app_name%/,  @app_name
  gsub_file local_path,  /%app_name_classify%/,  @app_name.classify
  gsub_file local_path,  /%working_user%/,  @working_user
  gsub_file local_path,  /%working_dir%/,  @working_dir
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
gem 'jquery-rails'
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
get "#{repo_url}/app/assets/stylesheets/application.css", 'app/assets/stylesheets/application.css'
get "#{repo_url}/app/assets/stylesheets/base.css.sass", 'app/assets/stylesheets/base.css.sass'
empty_directory 'app/assets/stylesheets/colors'
get "#{repo_url}/app/assets/stylesheets/colors/_colorlovers.css.sass", 'app/assets/stylesheets/colors/_colorlovers.css.sass'
get "#{repo_url}/app/assets/stylesheets/colors/_dom.css.sass", 'app/assets/stylesheets/colors/_dom.css.sass'
get "#{repo_url}/app/assets/stylesheets/colors/_rambaral.css.sass", 'app/assets/stylesheets/colors/_rambaral.css.sass'

get "#{repo_url}/app/assets/images/badge_grunge.png", 'app/assets/images/badge_grunge.png'
empty_directory 'app/assets/images/ico'
get "#{repo_url}/app/assets/images/ico/favicon.ico", 'app/assets/images/ico/favicon.ico'

# Views
remove_file 'app/views/layouts/application.html.erb'
get "#{repo_url}/app/views/layouts/application.html.haml", 'app/views/layouts/application.html.haml'
get "#{repo_url}/app/views/layouts/_flash.html.haml", 'app/views/layouts/_flash.html.haml'

# application.rb
initialize_on_precompile = <<EOS
    # Don't initialize on precompile
    config.assets.initialize_on_precompile = false
EOS
insert_into_file 'config/application.rb', initialize_on_precompile, after: "config.assets.version = '1.0'\n"

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
