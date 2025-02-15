# Called by the Hub application if an end user changes their details. We update
# our local records accordingly. Registered in config/application.rb through a
# call to HubSsoLib#hubssolib_register_user_change_handler.
#
# See the HubSsoLib gem's README.md for more information.
#
namespace :hub do
  desc 'Update a user with details sent from Hub'
  task :update_user, [:old_email, :old_name, :new_email, :new_name] => :environment do | t, args |
    user   = User.find_by_email(args[:old_email])
    user ||= User.find_by_display_name(args[:old_name])

    user&.update_columns(email: args[:new_email], display_name: args[:new_name])
  end
end
