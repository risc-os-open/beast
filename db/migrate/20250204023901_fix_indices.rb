class FixIndices < ActiveRecord::Migration[8.0]
  def up
    add_index :posts, :topic_id
    add_index :topics, :user_id

    add_index :monitorships, :topic_id
    add_index :monitorships, :user_id

    add_index :moderatorships, :user_id

    remove_index :posts, name: 'index_posts_on_user_id'
    add_index :posts, :user_id
  end

  def down
    remove_index :posts, :user_id
    add_index :posts, ["user_id", "created_at"], name: "index_posts_on_user_id"

    remove_index :moderatorships, :user_id

    remove_index :monitorships, :user_id
    remove_index :monitorships, :topic_id

    remove_index :topics, :user_id
    remove_index :posts, :topic_id
  end
end
