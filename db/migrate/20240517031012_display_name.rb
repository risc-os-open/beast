class DisplayName < ActiveRecord::Migration[7.1]
  def self.up
    add_column "users", "display_name", :string
  end

  def self.down
    remove_column "users", "display_name"
  end
end
