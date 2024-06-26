class ForumsController < ApplicationController
  before_action :find_or_initialize_forum, except: :index

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

  def index
    scope = Forum.all.order(position: :asc)
    @pagy, @forums = pagy(scope)

    respond_to do |format|
      format.html
      format.xml { render :xml => forums.to_xml }
    end
  end

  def show
    respond_to do |format|
      format.html do
        # keep track of when we last viewed this forum for activity indicators
        (session[:forums] ||= {})[@forum.id] = Time.now.utc if logged_in?

        topics = @forum
          .topics
          .includes(:replied_by_user)
          .order('sticky desc, replied_at desc')

        @pagy, @topics = pagy(topics)
      end

      format.xml do
        render :xml => @forum.to_xml
      end
    end
  end

  # new renders new.rhtml

  def create
    Forum.create!(forum_params())

    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head :created, :location => forum_url(:id => @forum, format: :xml) }
    end
  end

  def update
    @forum.update!(forum_params())

    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head 200 }
    end
  end

  def destroy
    @forum.destroy!

    respond_to do |format|
      format.html { redirect_to forums_path }
      format.xml  { head 200 }
    end
  end

  private

    def find_or_initialize_forum
      @forum = params[:id] ? Forum.find(params[:id]) : Forum.new
    end

    def forum_params
      params.require(:forum).permit(:name, :description)
    end

end
