xml.instruct! :xml, version: '1.0', encoding: "UTF-8"

xml.rss "version" => "2.0",
  'xmlns:opensearch' => "http://a9.com/-/spec/opensearch/1.1/",
  'xmlns:atom'       => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "ROOL Forum: Recent Posts in '#{@topic.title}'"
    xml.link forum_topic_url(@forum, @topic)
    xml.language "en-us"
    xml.ttl "60"
    xml.tag! "atom:link", :rel => 'search', :type => 'application/opensearchdescription+xml', :href => "http://#{request.host_with_port}/open_search.xml"
    xml.description @topic.posts.reorder(created_at: :asc).first&.body || @topic.title

    render :partial => "layouts/post", :formats => :xml, :collection => @posts, :locals => {:xm => xml}
  end
end
