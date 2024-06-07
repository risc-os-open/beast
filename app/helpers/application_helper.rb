module ApplicationHelper
  include Pagy::Frontend

  # Turn the Hub and Rails flash data into a simple series of H2 entries,
  # with Hub data first, Rails flash data next. A container DIV will hold
  # zero or more H2 entries:
  #
  #   <div class="flash">
  #     <h2 class="flash foo">Bar</h2>
  #   </div>
  #
  # ...where "foo" is the flash key, e.g. "alert", "notice" and "Bar" is
  # the flash value, made HTML-safe.
  #
  def apphelp_flash
    data = hubssolib_flash_data()
    html = ""

    return tag.div( :class => 'flash' ) do
      data[ 'hub' ].each do | key, value |
        concat( tag.h2( value, class: "flash #{ key }" ) )
      end

      data[ 'standard' ].each do | key, value |
        concat( tag.h2( value, class: "flash #{ key }" ) )
      end
    end
  end

  def submit_tag(value = "Save Changes", options = {} )
    or_option = options.delete(:or)
    return super + "<span class='button_or'>or " + or_option + "</span>" if or_option
    super
  end

  def ajax_spinner_for(id, spinner = "spinner.gif")
    "<img src='/images/#{spinner}' style='display:none; vertical-align:middle;' id='#{id.to_s}_spinner'> "
  end

  def avatar_for(user, size = 32)
    image_tag(
      "https://www.gravatar.com/avatar.php?gravatar_id=#{Digest::SHA256.hexdigest(user.email)}&size=#{size}",
      size:  "#{size}x#{size}",
      class: 'photo'
    )
  end

  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { url: url, title: title }
    link_to(image_tag('feed-icon.png', size: '14x14', alt: "Subscribe to #{title}"), url)
  end

  def search_posts_title
    title = if params[:q].blank?
      'Recent Posts'
    else
      "Searching for '#{h params[:q]}'"
    end

    title << " by #{h User.find(params[:user_id]).display_name}" if params[:user_id ].present?
    title << " in #{h Forum.find(params[:forum_id]).name}"       if params[:forum_id].present?

    return title
  end

  def search_posts_path(rss = false)
    search = params[:q].present?

    options          = {}
    options[:q     ] = params[:q] if search
    options[:format] = :rss       if rss

    # NOTE POSSIBLE EARLY EXIT
    #
    [[:user, :user_id], [:forum, :forum_id]].each do |(route_key, param_key)|
      if params[param_key].present?
        return send("#{route_key}_posts_path", options.update(param_key => params[param_key]))
      end
    end

    search ? search_all_posts_path(options) : all_posts_path(options)
  end

  def apphelp_pagination_fields
    "#{hidden_field_tag(:page,  params[:page ]) if params[:page ].present?}".html_safe() <<
    "#{hidden_field_tag(:items, params[:items]) if params[:items].present?}".html_safe()
  end

  # https://gist.github.com/mattyoho/1113828
  #
  def error_messages_for(*objects)
    options = objects.extract_options!

    options[:header_message] ||= I18n.t(:'activerecord.errors.header',  default: 'Invalid fields')
    options[:message       ] ||= I18n.t(:'activerecord.errors.message', default: 'Correct the following errors and try again.')

    messages = objects.compact.map { |o| o.errors.full_messages }.flatten

    unless messages.empty?
      content_tag(:div, class: 'error_messages') do
        list_items = messages.map { |msg| content_tag(:li, msg) }

        content_tag(:h2, options[:header_message]   ) +
        content_tag(:p,  options[:message       ]   ) +
        content_tag(:ul, list_items.join.html_safe())
      end
    end
  end
end
