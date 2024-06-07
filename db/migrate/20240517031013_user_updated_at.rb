class UserUpdatedAt < ActiveRecord::Migration[7.1]
  def self.up
    add_column "users", "updated_at", :datetime
  end

  def self.down
    remove_column "users", "updated_at"
  end
end
