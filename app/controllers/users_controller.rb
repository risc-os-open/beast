class UsersController < ApplicationController
  # before_action :find_user, only: [:edit, :update, :destroy, :admin]

  HUBSSOLIB_PERMISSIONS = HubSsoLib::Permissions.new(
    {
      :index    => [ :admin, :webmaster ],
      :show     => [ :admin, :webmaster, :privileged, :normal ],

      # Never use these.

      :new      => [ :admin ],
      :create   => [ :admin ],
      :edit     => [ :admin ],
      :update   => [ :admin ],
      :activate => [ :admin ],
      :admin    => [ :admin ],
      :destroy  => [ :admin ],
    }
  )

  def self.hubssolib_permissions
    HUBSSOLIB_PERMISSIONS
  end

  def index
    respond_to do |format|
      format.html do
        scope = User.search(params[:q], order: 'display_name ASC')
        @pagy, @users = pagy(scope)

        @user_count = User.count
        @active     = User.where('posts_count > 0').count
      end

      format.xml do
        @users = User.search(params[:q], limit: 25)
        render(xml: @users.to_xml)
      end
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render(xml: @user.to_xml) }
    end
  end

#   def new
#     @user = User.new
#   end
#
#   def create
#     respond_to do |format|
#       format.html do
#         if params[:email].present?
#           @user = User.find_by_email(params[:email])
#
#           if @user.nil?
#             flash[:error] = "I could not find an account with the email address '#{params[:email]}'. Did you type it correctly?"
#             redirect_to(login_path())
#             return # NOTE EARLY EXIT
#           end
#         else
#           @user = User.new(params[:user])
#         end
#
#         @user.login = params[:user][:login] unless params[:user].blank?
#         @user.reset_login_key!
#
#         UserMailer.deliver_signup(@user, request.host_with_port)
#         flash[:notice] = "#{params[:user].blank? ? "An account activation" : "A temporary login"} email has been sent to '#{CGI.escapeHTML @user.email}'."
#
#         redirect_to(login_path())
#       end
#     end
#   end
#
#   def activate
#     respond_to do |format|
#       format.html do
#         self.current_user = User.find_by_login_key(params[:key])
#
#         if logged_in? && !current_user.activated?
#           current_user.toggle! :activated
#           flash[:notice] = "Signup complete!"
#         end
#
#         redirect_to(root_path())
#       end
#     end
#   end
#
#   def update
#     @user.attributes = params[:user]
#
#     # TODO: Temporary fix to let people with dumb usernames change them
#     #
#     @user.login = params[:user][:login] if not @user.valid? and @user.errors.key?(:login)
#
#     @user.save!
#
#     respond_to do |format|
#       format.html { redirect_to(edit_user_path(@user, notice: 'Your settings have been saved')) }
#       format.xml  { head(200) }
#     end
#   end
#
#   def admin
#     respond_to do |format|
#       format.html do
#         @user.admin = params[:user][:admin] == '1'
#         @user.save!
#         @user.forums << Forum.find(params[:moderator]) unless params[:moderator].blank? || params[:moderator] == '-'
#
#         redirect_to user_path(@user)
#       end
#     end
#   end
#
#   def destroy
#     @user.destroy!
#
#     respond_to do |format|
#       format.html { redirect_to(users_path()) }
#       format.xml  { head(200) }
#     end
#   end

  protected

    def authorized?
      admin? || (!%w(destroy admin).include?(action_name) && (params[:id].nil? || params[:id] == current_user.id.to_s))
    end

    def find_user
      @user = params[:id] ? User.find(params[:id]) : current_user
    end
end
