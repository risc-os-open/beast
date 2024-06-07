class ReAddPostsForumId < ActiveRecord::Migration[7.1]
  def self.up
    add_column "posts", "forum_id", :integer
  end

  def self.down
    remove_column "posts", "forum_id"
  end
end
