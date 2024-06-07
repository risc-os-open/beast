class CreateModeratorships < ActiveRecord::Migration[7.1]
  def self.up
    create_table :moderatorships do |t|
      t.column :forum_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :moderatorships
  end
end
