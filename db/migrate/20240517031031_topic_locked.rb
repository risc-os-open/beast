class TopicLocked < ActiveRecord::Migration[7.1]
  def self.up
    add_column "topics", "locked", :boolean, default: false
  end

  def self.down
    remove_column "topics", "locked"
  end
end
