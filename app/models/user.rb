require 'digest/sha1'

class User < ApplicationRecord
  has_many :moderatorships, dependent: :destroy

  has_many(
    :forums,
    -> { order('forums.name ASC') },
    through: :moderatorships
  )

  has_many :posts
  has_many :topics
  has_many :monitorships

  has_many(
    :monitored_topics,
    -> { joins(:monitorships).where(monitorships: { active: true }).order('topics.replied_at DESC') },
    through: :monitorships,
    source:  :topic
  )

  # Commented out lots of stuff here. Users are built through
  # Hub now, so many of the requirements are invalid anyway. The
  # new replacement code is immediately below, before the old
  # commented out block.
  #
  validates_uniqueness_of :login

  attr_reader :password

  def self.currently_online
    User.where("last_seen_at > ?", Time.now.utc - 5.minutes)
  end

  # we allow false to be passed in so a failed login can check
  # for an inactive account to show a different error
  def self.authenticate(login, password, activated=true)
    self.where(
      login:         login,
      password_hash: Digest::SHA1.hexdigest(password + PASSWORD_SALT),
      activated:     activated
    ).first
  end

  def self.search(query, options = {})
    scope = self
    scope = scope.where(build_search_conditions(query))
    scope = scope.where(options.except(:order))
    scope = scope.order(options[:order]) if options.key?(:order)
    scope
  end

  def self.build_search_conditions(query)
    if query.present?
      safe_downcase_query = ActiveRecord::Base.sanitize_sql_like(query).downcase()
      ['LOWER(display_name) LIKE :q OR LOWER(login) LIKE :q', {:q => "%#{safe_downcase_query}%"}]
    else
      '1=0'
    end
  end

  def password=(value)
    return if value.blank?
    write_attribute :password_hash, Digest::SHA1.hexdigest(value + PASSWORD_SALT)
    @password = value
  end

  def reset_login_key!
    self.login_key = Digest::SHA1.hexdigest(Time.now.to_s + password_hash.to_s + rand(123456789).to_s).to_s
    # this is not currently honored
    self.login_key_expires_at = Time.now.utc+1.year
    save!
    login_key
  end

  def moderator_of?(forum)
    moderatorships.where(forum_id: (forum.is_a?(Forum) ? forum.id : forum)).any?
  end

  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :email << :login_key << :login_key_expires_at << :password_hash
    super
  end
end
