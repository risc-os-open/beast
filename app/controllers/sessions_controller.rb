class SessionsController < ApplicationController
  HUBSSOLIB_PERMISSIONS = HubSsoLib::Permissions.new(
    {
      :new     => [ :admin ],
      :create  => [ :admin, :webmaster, :privileged, :normal ],
      :edit    => [ :admin ],
      :update  => [ :admin ],
      :destroy => [ :admin ],
    }
  )

  def self.hubssolib_permissions
    HUBSSOLIB_PERMISSIONS
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    redirect_to root_path() and return

    # Old pre-Hub code

    if logged_in?
      cookies[:login_token]={ :value => "#{current_user.id};#{current_user.reset_login_key!}", :expires => Time.now.utc+1.year } if params[:remember_me]=="1"
      redirect_to root_path() and return
    end
    flash.now[:error] = "Invalid login or password, try again please."
    flash.now[:error] = "Your account has not been activated. Use 'reset password' to be sent another activation e-mail." if User.authenticate(params[:login], params[:password], false)
    render :action => 'new'
  end

  def destroy
    reset_session
    cookies.delete :login_token
    flash[:notice] = "You have been logged out."
    redirect_to root_path()
  end
end
