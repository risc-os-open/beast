class AddContactFields < ActiveRecord::Migration[7.1]
  def self.up
    add_column "users", "aim", :string
    add_column "users", "yahoo", :string
    add_column "users", "google_talk", :string
    add_column "users", "msn", :string
    add_column "users", "website", :string
  end

  def self.down
    remove_column "users", "aim"
    remove_column "users", "yahoo"
    remove_column "users", "google_talk"
    remove_column "users", "msn"
    remove_column "users", "website"
  end
end
