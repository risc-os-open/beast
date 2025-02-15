source 'https://rubygems.org'

gem 'rails', '~> 8'

# Use PostgreSQL
#
gem 'pg', '~> 1.5'

# Use the Puma web server [https://github.com/puma/puma]
#
gem 'puma', '~> 6.0'

# Simple asset management [https://github.com/rails/propshaft]
#
gem 'propshaft', '~> 1.1'

# For Windows or esoteric Unix/Linux-like distributions.
#
gem 'tzinfo-data'

# Use Hub for authentication [https://github.com/pond/hubssolib]
#
gem 'hubssolib', '~> 3.2', require: 'hub_sso_lib'

# Easy pagination [https://rubygems.org/gems/pagy]
#
gem 'pagy', '~> 9.3'

# Textile support [https://rubygems.org/gems/RedCloth]
#
gem 'RedCloth', '~> 4.3'

# HTML processing [https://rubygems.org/gems/html-pipeline]
#
gem 'html-pipeline', '~> 3.2'

# Replace Rails <= 3.0 'auto_link' [https://rubygems.org/gems/rails_autolink]
#
gem 'rails_autolink', '~> 1.1'

# List positioning [https://rubygems.org/gems/acts_as_list]
#
gem 'acts_as_list', '~> 1.2'

# Monitoring and alerting [http://sentry.io]
#
# * https://rubygems.org/gems/stackprof
# * https://rubygems.org/gems/sentry-ruby
# * https://rubygems.org/gems/sentry-rails
#
gem 'stackprof'
gem 'sentry-ruby'
gem 'sentry-rails'

group :development, :test do

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  #
  gem 'debug', platforms: %i[ mri windows ]

end

group :development do

  # Use console on exceptions pages [https://github.com/rails/web-console]
  #
  gem 'web-console'

  # Be able to run 'bin/dev' [https://github.com/ddollar/foreman]
  #
  gem 'foreman'

  # E-mail inspection [https://rubygems.org/gems/mailcatcher]
  #
  gem 'mailcatcher'

  # Database analytics [https://github.com/pawurb/rails-pg-extras]
  #
  gem "rails-pg-extras"

end

group :test do

  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  #
  gem 'capybara'
  gem 'selenium-webdriver'

end
