class AddHits < ActiveRecord::Migration[7.1]
  def self.up
    add_column "posts", "hits", :integer, :default => 0 
  end

  def self.down
    remove_column "posts", "hits"
  end
end
