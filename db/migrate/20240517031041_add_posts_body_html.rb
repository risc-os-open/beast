class AddPostsBodyHtml < ActiveRecord::Migration[7.1]
  def self.up
    add_column "posts",  "body_html",        :text
    add_column "users",  "bio_html",         :text
    add_column "forums", "description_html", :text
  end

  def self.down
    remove_column "posts", "body_html"
    remove_column "users", "bio_html"
    remove_column "forums", "description_html"
  end
end
