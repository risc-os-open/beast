# 2019-01-26 (ADH):
#
# Very simplistic quick-and-dirty implementation; Blacklist has just one
# row, which contains a text field of newline separated items processed
# by Ruby when checking a post. Not efficient but sufficient for now.
#
class AddBlacklist < ActiveRecord::Migration[7.1]
  def self.up
    create_table :blacklists do |t|
      t.column :list, :text, default: ''
    end
  end

  def self.down
    drop_table :blacklists
  end
end
