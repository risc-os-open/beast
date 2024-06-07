class AddTopicLastPostedAtDate < ActiveRecord::Migration[7.1]
  def self.up
    add_column "posts", "replied_at", :datetime
  end

  def self.down
    remove_column "posts", "replied_at"
  end
end
