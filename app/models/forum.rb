class Forum < ApplicationRecord
  include WhiteListFormattedContentConcern

  acts_as_list()

  validates_presence_of :name
  format_attribute :description

  has_many(
    :moderatorships,
    dependent: :destroy
  )

  has_many(
    :moderators,
    -> { order('users.login ASC') },
    through: :moderatorships,
    source:  :user
  )

  # was has_many ... do
  #   def first
  #     @first_topic ||= find(:first)
  #   end
  # end
  #
  has_many(
    :topics,
    -> { order('sticky desc, replied_at desc') },
    dependent: :destroy
  )

  # was has_many ... do
  #   def last
  #     @last_post ||= find(:first)
  #   end
  # end
  #
  has_many(
    :posts,
    -> { order('posts.created_at desc') }
  )
end
