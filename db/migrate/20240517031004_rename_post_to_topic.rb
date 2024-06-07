class RenamePostToTopic < ActiveRecord::Migration[7.1]
  def self.up
    rename_column :posts, :post_id, :topic_id
  end

  def self.down
    rename_column :posts, :topic_id, :post_id
  end
end
