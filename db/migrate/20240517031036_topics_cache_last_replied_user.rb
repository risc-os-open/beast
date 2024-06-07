class TopicsCacheLastRepliedUser < ActiveRecord::Migration[7.1]
  def self.up
    add_column "topics", "replied_by", :integer
    add_column "topics", "last_post_id", :integer
  end

  def self.down
    remove_column "topics", "replied_by"
    remove_column "topics", "last_post_id"
  end
end
