class ModeratorsController < ApplicationController
  alias authorized? admin?
  HUBSSOLIB_PERMISSIONS = HubSsoLib::Permissions.new(
    {
      :new     => [ :admin, :webmaster ],
      :create  => [ :admin, :webmaster ],
      :edit    => [ :admin, :webmaster ],
      :update  => [ :admin, :webmaster ],
      :destroy => [ :admin, :webmaster ],
    }
  )

  def self.hubssolib_permissions
    HUBSSOLIB_PERMISSIONS
  end

  def destroy
    Moderatorship.find(params[:id]).delete
    redirect_to user_path(params[:user_id])
  end
end
