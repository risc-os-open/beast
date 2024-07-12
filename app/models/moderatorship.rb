class Moderatorship < ApplicationRecord
  belongs_to :forum
  belongs_to :user

  # TODO: This should probably be a validation combined with a database
  # TODO: constraint. It's certainly an inventive way to say "no existing
  # TODO: record for this forum and user should exist"!
  #
  before_create do |r|
    if Monitorship.where(user_id: r.user_id, forum_id: r.forum_id).any?
      throw :abort
    end
  end
end
