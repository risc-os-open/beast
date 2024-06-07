require 'digest/sha1'
class AddPasswordHash < ActiveRecord::Migration[7.1]
  def self.up
    raise "ChangePasswordHash" if PASSWORD_SALT == '48e45be7d489cbb0ab582d26e2168621'

    rename_column :users, :password, :password_hash
  end

  def self.down
    raise IrreversibleMigration
  end
end
