source 'https://gems.ruby-china.com'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'json'
gem 'excel2csv'
gem 'spreadsheet'
gem "default_value_for"
gem 'ruby-pinyin'
gem 'batch_api'
gem 'whenever', :require => false
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
gem 'mongo', '~> 2.11.3'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'ancestry'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
# 读取excel
gem 'simple_xlsx_reader', '~> 1.0.2'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# mqtt通讯
gem 'mqtt'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'jwt'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'ransack'
gem "paperclip"
gem 'kaminari'
gem 'simple_command'
# 图文验证码
# gem 'simple_captcha2', require: 'simple_captcha'
gem 'simple_captcha2', github: "rd084c/simple-captcha"
gem 'mini_magick', '~> 4.8.0'
# , github: "iTianchuang/simple-captcha"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'guard', '~>2.14.2',require:false
  gem 'guard-rspec','~>4.7.3',require:false
  gem 'rubocop-rspec'
  gem 'foreman'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'apiblueprint-rails'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
    gem 'factory_bot_rails', '~> 4.0'
    gem 'shoulda-matchers', '~> 3.1'
    gem 'faker'
    gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
