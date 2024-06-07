class ChangeStickyToInteger < ActiveRecord::Migration[7.1]
  def self.up
    change_column :topics, :sticky, :integer, :default => 0
  end

  def self.down
    change_column :topics, :sticky, :boolean, :default => false
  end
end
