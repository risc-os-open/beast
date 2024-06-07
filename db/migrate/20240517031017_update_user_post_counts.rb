class UpdateUserPostCounts < ActiveRecord::Migration[7.1]
  def self.up
    remove_column "users", "topics_count"
  end

  def self.down
    raise IrreversibleMigration
  end
end
