RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :session_key => '_omniture_implementation_generator_session',
    :secret      => '77ed651a3cb86624d4c3ae4b2dd887bc40cd0afd76de7d9a3fa3db1b913e2291101c10f38537b2bbf067dfdd2b762ae901559d8d5cba3596130c3ef2da56e6c4'
  }
end
