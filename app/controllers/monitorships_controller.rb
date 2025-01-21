class MonitorshipsController < ApplicationController
  HUBSSOLIB_PERMISSIONS = HubSsoLib::Permissions.new(
    {
      :new     => [ :admin, :webmaster, :privileged, :normal ],
      :create  => [ :admin, :webmaster, :privileged, :normal ],
      :edit    => [ :admin, :webmaster, :privileged, :normal ],
      :update  => [ :admin, :webmaster, :privileged, :normal ],
      :destroy => [ :admin, :webmaster, :privileged, :normal ],
    }
  )

  def self.hubssolib_permissions
    HUBSSOLIB_PERMISSIONS
  end

  def create
    @monitorship = Monitorship.find_or_initialize_by(user_id: current_user.id, topic_id: params[:topic_id])
    @monitorship.active = true
    @monitorship.save!

    respond_to do |format|
      format.html { redirect_to forum_topic_path(forum_id: params[:forum_id], id: params[:topic_id]) }
    end
  end

  def destroy
    # Beast HEAD does the following, but this leaks monitorships into
    # the database indefinitely, merely setting "active = t" or "f"
    # flags everywhere. The Posts controller just checks for the row
    # entries that match post and user ID, but not the active flag.
    # To make life simpler, just delete Monitorship entries that match
    # the given details.

    # Monitorship.where(user_id: current_user.id, topic_id: params[:topic_id).update_all(active: false)

    monitorship = Monitorship.where(user_id: current_user.id, topic_id: params[:topic_id]).first
    monitorship.destroy! if monitorship

    respond_to do |format|
      format.html { redirect_to forum_topic_path(forum_id: params[:forum_id], id: params[:topic_id]) }
    end
  end
end
