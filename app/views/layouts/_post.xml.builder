xm.item do
  xm.title       h(post.respond_to?(:topic_title) ? post.topic_title : post.topic.title)
  xm.description post.body_html
  xm.pubDate     post.created_at.rfc822
  xm.guid        [request.host_with_port, post.forum_id.to_s, post.topic_id.to_s, post.id.to_s].join(':'), isPermaLink: 'false'
  xm.author      h(post.user.display_name)
  xm.link        forum_topic_url(post.forum_id, post.topic_id)
end
