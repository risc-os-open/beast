class AddForumDesc < ActiveRecord::Migration[7.1]
  def self.up
    add_column "forums", "description", :string
  end

  def self.down
    remove_column "forums", "description"
  end
end
