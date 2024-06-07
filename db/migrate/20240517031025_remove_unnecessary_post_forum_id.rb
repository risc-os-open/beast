class RemoveUnnecessaryPostForumId < ActiveRecord::Migration[7.1]
  def self.up
    remove_column :posts, :forum_id
  end

  def self.down
    add_column :posts, :forum_id, :integer
  end
end
