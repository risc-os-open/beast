# 2019-01-31 (ADH):
#
# Addition to the blacklist system for topic titles, in a separate list.
#
class AddTitleBlacklist < ActiveRecord::Migration[7.1]
  def self.up
    add_column :blacklists, :title_list, :text, default: ''
  end

  def self.down
    remove_column :blacklists, :title_list
  end
end
