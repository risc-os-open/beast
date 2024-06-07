class EmpowerSessions < ActiveRecord::Migration[7.1]
  def self.up
    add_column "sessions", "user_id", :integer
  end

  def self.down
    remove_column "sessions", "user_id"
  end
end
