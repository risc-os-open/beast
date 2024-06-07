class LastSeenAt < ActiveRecord::Migration[7.1]
  def self.up
    add_column "users", "last_seen_at", :datetime
  end

  def self.down
    remove_column "users", "last_seen_at"
  end
end
