class TopicsController < ApplicationController
  before_action :find_forum_and_topic, except: :index

  HUBSSOLIB_PERMISSIONS = HubSsoLib::Permissions.new(
    {
      :new     => [ :admin, :webmaster, :privileged, :normal ],
      :create  => [ :admin, :webmaster, :privileged, :normal ],
      :edit    => [ :admin, :webmaster ],
      :update  => [ :admin, :webmaster ],
      :destroy => [ :admin, :webmaster ],
    }
  )

  def self.hubssolib_permissions
    HUBSSOLIB_PERMISSIONS
  end

  def index
    respond_to do |format|
      format.html do
        redirect_to(forum_path(params[:forum_id]))
      end

      format.xml do
        @topics = Topic
          .where(forum_id: params[:forum_id])
          .order('sticky desc, replied_at desc')
          .limit(25)

        render(xml: @topics.to_xml)
      end
    end
  end

  def new
    @topic = Topic.new
  end

  def show
    respond_to do |format|
      format.html do
        update_last_seen_at() # (see 'lib/authentication_system.rb')

        # Keep track of when we last viewed this topic for activity indicators
        #
        (session[:topics] ||= {})[@topic.id] = Time.now.utc if logged_in?

        # Authors of topics don't get counted towards total hits
        #
        @topic.hit! unless logged_in? and @topic.user == current_user

        scope = Post
          .includes(:user)
          .where(topic_id: params[:id])
          .order(created_at: :asc)

        @pagy, @posts = pagy(scope)

        @voices = User.distinct.where(id: @posts.select(:user_id))
        @post   = Post.new
      end

      format.xml do
        render(xml: @topic.to_xml)
      end

      format.rss do
        @posts = @topic.posts.order(created_at: :desc).limit(50)
        render(action: 'show.xml.erb', layout: false)
      end
    end
  end

  # TODO: move the topic/first post workings into the topic model?
  #
  def create
    Topic.transaction do
      @topic       = Topic.new
      @topic.user  = current_user
      @topic.forum = @forum
      @topic.assign_attributes(self.topic_params().except(:body))
      @topic.save!

binding.b

      @post       = Post.new
      @post.user  = current_user
      @post.topic = @topic
      @post.body  = params.dig(:topic, :body)
      @post.save!

binding.b
    end

    respond_to do |format|
      format.html { redirect_to(forum_topic_path(forum_id: @forum.id, id: @topic.id)) }
      format.xml  { head(:created, location: topic_url(id: @topic.id, forum_id: @forum, format: :xml)) }
    end

  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Your topic's first post was empty, or contained prohibited words"

    respond_to do |format|
      format.html { redirect_to(forum_path(@forum)) }
      format.xml  { render(xml: @post.errors.to_xml, status: 400) }
    end
  end

  def update
    @topic.update!(self.topic_params())

    respond_to do |format|
      format.html { redirect_to(forum_topic_path(forum_id: @forum.id, id: @topic.id)) }
      format.xml  { head(200) }
    end
  end

  def destroy
    @topic.destroy!

    flash[:notice] = "Topic '#{CGI::escapeHTML @topic.title}' was deleted."

    respond_to do |format|
      format.html { redirect_to(forum_path(@forum)) }
      format.xml  { head(200) }
    end
  end

  private

    # The creation form is unusual; a Topic is created with a given title and
    # some possibly protected attributes, then a first Post is created within
    # that topic with body text given within the topic form.
    #
    # We permit the "body" field just to keep strong parameters happy.
    #
    def topic_params
      permitted = [:title]

      if @topic.new_record?
        permitted << :body
      end

      if admin?
        if current_user.moderator_of?(@topic.forum)
          permitted << :sticky
          permitted << :locked
        end

        unless @topic.new_record?
          permitted << :forum_id
        end
      end

      params.require(:topic).permit(*permitted)
    end

    def find_forum_and_topic
      @forum = Forum.find(params[:forum_id])
      @topic = @forum.topics.find(params[:id]) if params[:id]
    end

    def authorized?
      %w(new create).include?(action_name) || @topic.editable_by?(current_user)
    end
end
