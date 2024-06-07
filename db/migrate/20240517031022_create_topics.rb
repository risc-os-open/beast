class CreateTopics < ActiveRecord::Migration[7.1]
  def self.up
    create_table :topics do |t|
      t.column "forum_id",    :integer
      t.column "user_id",     :integer
      t.column "title",       :string
      t.column "created_at",  :datetime
      t.column "updated_at",  :datetime
      t.column "hits",        :integer,  :default => 0
      t.column "sticky",      :boolean,  :default => false
      t.column "posts_count", :integer,  :default => 0
      t.column "replied_at",  :datetime
    end
  end

  def self.down
    drop_table :topics
  end
end
