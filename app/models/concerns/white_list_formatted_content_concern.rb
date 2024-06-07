require 'html-pipeline'
require 'selma'

module WhiteListFormattedContentConcern
  extend ActiveSupport::Concern

  # https://github.com/gjtorikian/html-pipeline#convertfilter
  #
  class RedClothConvertFilter < HTMLPipeline::ConvertFilter
    def call(text, context: @context)
      return RedCloth.new(text).to_html()
    end
  end

  # https://github.com/gjtorikian/html-pipeline#nodefilters
  #
  class FootnoteNodeFilter < HTMLPipeline::NodeFilter
    attr_accessor :fn_id_sfx

    SELECTOR             = Selma::Selector.new(match_element: "sup.footnote, p.footnote, a")
    FOOTNOTE_NAME_REGEXP = Regexp.new('^fnr?\d+$')  # E.g. "fn30" or "fnr30"
    FOOTNOTE_HREF_REGEXP = Regexp.new('^#fnr?\d+$') # E.g. "#fn30" or "#fnr30"

    def selector
      SELECTOR
    end

    def handle_element(element)
      if element.tag_name == "a"
        match = FOOTNOTE_NAME_REGEXP.match(element['id'] || '')
        element['id'] << fn_id_sfx if (match)
      else
        match = FOOTNOTE_HREF_REGEXP.match(element['href'] || '')
        element['href'] << fn_id_sfx if (match)
      end
    end
  end

  included do
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include WhiteListHelper

    def self.format_attribute(attr_name)
      class << self; include ActionView::Helpers::TagHelper, ActionView::Helpers::TextHelper, WhiteListHelper; end
      define_method(:body)       { read_attribute attr_name }
      define_method(:body_html)  { read_attribute "#{attr_name}_html" }
      define_method(:body_html=) { |value| write_attribute "#{attr_name}_html", value }
      before_save :format_content
    end

    def dom_id
      [self.class.name.downcase.pluralize.dasherize, id] * '-'
    end

    protected

      def format_content
        body.strip! if body.respond_to?(:strip!)
        self.body_html = body.blank? ? '' : body_html_with_formatting
      end

      # 2013-09-04 (ADH): See "body_html_with_formatting" for details.
      #
      @@footnote_name_regexp = Regexp.new('^fnr?\d+$')  # E.g. "fn30" or "fnr30"
      @@footnote_href_regexp = Regexp.new('^#fnr?\d+$') # E.g. "#fn30" or "#fnr30"

      def body_html_with_formatting

        # 2013-09-04 (ADH):
        #
        # On the assumption we are called within a new Post or an edited Post,
        # generate a reasonably-likely-to-be-unique ID. We can't use the model
        # ID as in the "new" case it hasn't been saved yet so doesn't have one.
        #
        # We'll use this to patch up Textile footnote references. There's no
        # way to ask Textile to add a suffix to the IDs and names it generates,
        # so instead post-process the output since we're being called for all
        # generated HTML nodes by the white list engine anyway (see
        # WhiteListHelper stuff in "config/environment.rb" for details). If we
        # don't do this, multiple posts on a page can contain the same footnote
        # IDs/names resulting in invalid HTML and useless HTML anchors.
        #
        # Since the ID is only used for that specific case, we're not *too*
        # worried if it turns out to be non-unique, but given it's based on
        # the time of day down to the microsecond and the post's user ID, it
        # is *extremely* unlikely that a real user would be able to generate
        # two posts with the same ID suffix for footnotes!
        #
        now       = Time.now
        magic_id  = self.respond_to?(:user_id) ? (self.user_id || 0) : 0
        fn_id_sfx = "#{now.to_i}#{now.usec}#{magic_id}"

        # This could be switchable to Markdown one day.
        #
        # convert_filter = HTMLPipeline::ConvertFilter::MarkdownFilter.new
        # node_filter    = ...footnote filter for Markdown...
        #
        convert_filter        = RedClothConvertFilter.new
        node_filter           = FootnoteNodeFilter.new
        node_filter.fn_id_sfx = fn_id_sfx

        pipeline = HTMLPipeline.new(
          convert_filter:      convert_filter,
          sanitization_config: HTMLPipeline::SanitizationFilter::DEFAULT_CONFIG,
          node_filters:        [ node_filter ]
        )

        unsafe_html = auto_link body { |text| truncate(text, 50) }
        result      = pipeline.call(unsafe_html)

        return result[:output].html_safe()









#         # Generate the body by auto-linking, running through RedCloth and then
#         # passing it to the white list engine which in turn calls back for all
#         # of the HTML nodes.
#         #
#         body_html = auto_link body { |text| truncate(text, 50) }
#         white_list(RedCloth.new(body_html).to_html) do | node, bad |
#           if WhiteListHelper.bad_tags.include?(bad)
#             node.to_s.gsub(/</, '&lt;')
#           else
#             node.class == HTML::Tag && node.attributes && case(bad)
#               when "sup", "p"
#                 if (node.attributes['class'] == 'footnote')
#                   match = @@footnote_name_regexp.match(node.attributes['id'] || '')
#                   node.attributes['id'] << fn_id_sfx if (match)
#                 end
#               when "a"
#                 match = @@footnote_href_regexp.match(node.attributes['href'] || '')
#                 node.attributes['href'] << fn_id_sfx if (match)
#             end
#
#             node.to_s
#           end
#         end
      end
  end
end
