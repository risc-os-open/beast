class ApplicationController < ActionController::Base
  include AuthenticationSystem
  include Pagy::Backend

  # Hub single sign-on support. Run the Hub filters for all actions to ensure
  # activity timeouts etc. work properly. The login integration with Hub is
  # done using modifications to the forum's own mechanism in
  # 'lib/authentication_system.rb'.
  #
  require 'hub_sso_lib'
  include HubSsoLib::Core

  before_action :hubssolib_beforehand
  after_action  :hubssolib_afterwards

  # # Rescue all exceptions (bad form) to rotate the Hub key (good) and raise
  # # the exception again (so not bad form, after all).
  # #
  # rescue_from ::Exception, with: :on_error_rotate_and_raise

  # Beast's usual preamble.
  #
  helper_method :current_user, :logged_in?, :admin?, :last_active
  before_action :login_by_token

  protected

    def last_active
      session[:last_active] ||= Time.now.utc
    end

  private

    # TODO: Does not work as expected yet.
    #
    def on_error_rotate_and_raise
      hubssolib_set_last_used(Time.now.utc)
      hubssolib_afterwards()

      raise
    end

end
