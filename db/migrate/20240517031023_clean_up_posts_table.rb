class CleanUpPostsTable < ActiveRecord::Migration[7.1]
  def self.up
    remove_column "posts", "title"
    remove_column "posts", "hits"
    remove_column "posts", "sticky"
    remove_column "posts", "posts_count"
    remove_column "posts", "replied_at"
  end

  def self.down
  end
end
