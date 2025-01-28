class AddUsefulIndices < ActiveRecord::Migration[8.0]

  # There used to be an index on topics with 'sticky' and 'replied_at' (but
  # not with the DESC specifier, which is the more common sort use case in the
  # real code base). This was changed to include forum_id as a first column in
  # "20240517031045_tweak_forum_index.rb" but, strangely, kept the old name.
  #
  # Via EXPLAIN, PostgreSQL seems to prefer the simpler index and will run a
  # typical "get sorted topics for forum" index view query faster using it. We
  # leave the older, more complex index in place just in case PostgreSQL wants
  # to use it.
  #
  def change
    rename_index :posts, :index_topics_on_sticky_and_replied_at, :index_topics_on_forum_id_and_sticky_and_replied_at

    add_index :posts, :created_at,             order: { created_at: :desc }
    add_index :topics, [:sticky, :replied_at], order: { sticky:     :desc }
  end
end
