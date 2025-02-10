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

  # Rescue all exceptions (bad form) to rotate the Hub key (good) and render or
  # raise the exception again (rapid reload for default handling).
  #
  rescue_from ::Exception, with: :on_error_rotate_and_raise

  # Beast's usual preamble.
  #
  helper_method :current_user, :logged_in?, :admin?, :last_active
  before_action :login_by_token

  protected

    def last_active
      session[:last_active] ||= Time.now.utc
    end

  private

    # Used for the unusual range of ".foo" formats that might arise for a
    # family of XML-based responses; #on_error_rotate_and_raise needs to
    # know what the format in which to render an error.
    #
    XML_LIKE_MAP = {
      xml:           'application/xml',
      rss:           'application/rss+xml',
      rss20:         'application/rss+xml',
      atom:          'application/atom+xml',
      atom10:        'application/atom+xml',
      rsd:           'application/rsd+xml',
      googlesitemap: 'application/xml',
    }

    XML_LIKE_MAP.each do | format, mime |
      known_mime = Mime::Type.lookup_by_extension(format)
      Mime::Type.register(mime, format) if known_mime.blank?
    end

    XML_LIKE_FORMATS = XML_LIKE_MAP.keys.freeze

    # Renders an exception, retaining Hub login. Regenerate any exception
    # within five seconds of a previous render to 'raise' to default Rails
    # error handling, which (in non-Production modes) gives additional
    # debugging context and an inline console, but loses the Hub session
    # rotated key, so you're logged out.
    #
    def on_error_rotate_and_raise(exception)
      hubssolib_get_session_proxy()
      hubssolib_afterwards()

      if session[:last_exception_at].present?
        last_at = Time.parse(session[:last_exception_at]) rescue nil
        raise if last_at.present? && Time.now - last_at < 5.seconds
      end

      session[:last_exception_at] = Time.now.iso8601(1)
      locals                      = { exception: exception }

      Sentry.capture_exception(exception)

      # Depending on application, XML variants can be numerous - e.g. ".rss",
      # ".rss20" and so-on - so use that as a default for anything that is not
      # otherwise explicitly recognised as a JSON or HTML request.
      #
      respond_to do | format |
        format.html { render 'exception', locals: locals }
        format.json { render 'exception', locals: locals, formats: :json }

        format.any(*XML_LIKE_FORMATS) do
          render 'exception', locals: locals, formats: :xml
        end
      end
    end

end
