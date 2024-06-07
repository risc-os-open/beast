# 2019-01-26 (ADH):
#
# Very simplistic quick-and-dirty implementation; Blacklist has just one
# row, which contains a text field of newline separated items processed
# by Ruby when checking a post. Not efficient but sufficient for now.
#
class BlacklistController < ApplicationController
  HUBSSOLIB_PERMISSIONS = HubSsoLib::Permissions.new(
    {
      :show    => [ :admin, :webmaster ],
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

  public

    def show
      @blacklist = Blacklist.first
    end

    def new
      @blacklist = Blacklist.new
    end

    def create
      set_list_to( params[ :blacklist ] )
      redirect_to( blacklist_path(), notice: 'Prohibition list created' )
    end

    def edit
      @blacklist = Blacklist.first
    end

    def update
      set_list_to( params[ :blacklist ] )
      redirect_to( blacklist_path(), notice: 'Prohibition list updated' )
    end

    def destroy
      set_list_to( { :list => '', :title_list => '' } )
      redirect_to( blacklist_path(), notice: 'Prohibition list emptied' )
    end

  private

    def set_list_to( options )
      list       = options[ :list       ]
      title_list = options[ :title_list ]

      blacklist = if Blacklist.count > 0
        Blacklist.first
      else
        Blacklist.new
      end

      blacklist.list       = list
      blacklist.title_list = title_list
      blacklist.save!
    end

end
