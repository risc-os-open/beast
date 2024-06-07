class AddActivatedBoolean < ActiveRecord::Migration[7.1]
  def self.up
    add_column "users", "activated", :boolean, default: false
  end

  def self.down
    remove_column "users", "activated"
  end
end
