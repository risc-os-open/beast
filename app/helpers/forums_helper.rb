module ForumsHelper

  # used to know if a topic has changed since we read it last
  def recent_topic_activity(topic)
    return false unless logged_in?
    return topic.replied_at > (session[:topics][topic.id] || last_active)
  end

  # used to know if a forum has changed since we read it last
  def recent_forum_activity(forum)
    return false unless logged_in?

    new_normal = forum.topics.where(sticky: 0).first
    new_sticky = forum.topics.where(sticky: 1).first

    return (!new_normal.nil? && recent_topic_activity(new_normal)) ||
           (!new_sticky.nil? && recent_topic_activity(new_sticky))
  end
end
