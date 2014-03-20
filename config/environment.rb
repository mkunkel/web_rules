# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
WebRules::Application.initialize!
I18n.enforce_available_locales = false
