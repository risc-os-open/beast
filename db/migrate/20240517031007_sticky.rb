class Sticky < ActiveRecord::Migration[7.1]
  def self.up
    add_column "posts", "sticky", :boolean, :default => false
  end

  def self.down
    remove_column "posts", "sticky"
  end
end
