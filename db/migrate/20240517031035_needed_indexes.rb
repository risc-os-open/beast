class NeededIndexes < ActiveRecord::Migration[7.1]
  def self.up
    add_index :posts, :user_id
    add_index :posts, :topic_id
    add_index :topics, :forum_id
  end

  def self.down
    remove_index :posts, :user_id
    remove_index :posts, :topic_id
    remove_index :topics, :forum_id
  end
end
