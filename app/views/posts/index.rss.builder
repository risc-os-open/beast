xml.instruct! :xml, version: '1.0', encoding: "UTF-8"

xml.rss "version" => "2.0",
  'xmlns:opensearch' => "http://a9.com/-/spec/opensearch/1.1/",
  'xmlns:atom'       => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "ROOL Forum: #{search_posts_title}"
    xml.link "http://#{request.host_with_port}#{search_posts_path}"
    xml.language "en-us"
    xml.ttl "60"
    unless params[:q].blank?
      xml.tag! "opensearch:totalResults", @pagy.count
      xml.tag! "opensearch:startIndex", (@pagy.page - 1) * @pagy.limit
      xml.tag! "opensearch:itemsPerPage", @pagy.limit
      xml.tag! "opensearch:Query", :role => 'request', :searchTerms => params[:q], :startPage => @pagy.page
    end
    render :partial => "layouts/post", :formats => :xml, :collection => @posts, :locals => {:xm => xml}
  end
end
