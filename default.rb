#GemFile
run 'rm Gemfile'
file 'Gemfile', <<-CODE
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/\#{repo}.git" }

ruby '2.4.1'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'jquery-rails'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'jquery-ui-rails'
gem 'font-awesome-rails'
gem 'simple_form'
gem 'carrierwave'
gem 'faker'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'launchy'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
CODE

#.gitignore
run 'rm .gitignore'
file '.gitignore', <<-CODE
# Ignore bundler config.
/.bundle

# Ignore all logfiles and tempfiles.
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep

/node_modules
/yarn-error.log

.byebug_history

# Ignore other unneeded files.
*.swp
*~
.project
.DS_Store
.idea
.secret
/vendor/bundle/*
/public/uploads/*
/coverage/*
CODE

#edit config/application.rb
application do
  %q{
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.i18n.default_locale = :ja

    config.generators do |g|
      g.test_framework :rspec, view_specs: false, helper_specs: false, routing_specs: false
    end
  }
end

#set japanese
run 'curl -s https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml -o config/locales/ja.yml'
run 'curl -s https://raw.githubusercontent.com/tigrish/devise-i18n/master/rails/locales/ja.yml -o config/locales/devise.ja.yml '

#Simple Form
generate 'simple_form:install --bootstrap'

#erb to haml
run 'rails haml:erb2haml'

#db create
run 'rails db:create'

#css
run 'rm app/assets/stylesheets/application.css'
file 'app/assets/stylesheets/application.sass', <<-CODE
@import "bootstrap-sprockets"
@import "bootstrap"
@import "font-awesome"
CODE

#js
run 'rm app/assets/javascripts/application.js'
file 'app/assets/javascripts/application.js', <<-CODE
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require bootstrap-sprockets
//= require_tree .
CODE

#devise
if yes?('Use devise?')
  gem 'devise'
  generate 'devise:install'
  generate 'devise User'
  generate 'devise:controllers users'
  generate 'devise:views'
end

#git
git :init
git add: "."
git commit: "-a -m 'Initial commit'"

#GitHub
if yes?('Use GitHub?')
  github_url = ask('GitHubのリモートリポジトリのURLを入力してください')
  run "git remote add origin #{github_url}"
end

#rspec
generate 'rspec:install'

insert_into_file 'spec/rails_helper.rb', %{
  config.include FactoryBot::Syntax::Methods
}, after: 'RSpec.configure do |config|'

insert_into_file '.rspec', %{
--format documentation
}, after: '--require spec_helper'

