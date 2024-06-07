# See lib/white_list_helper.rb.
#
Rails.application.config.to_prepare do

  # 2013-09-04 (ADH): A custom vendor/plugins/white_list implementation
  # allows for empty attributes lists, meaning "pass all". We use its
  # block parameter to pass a custom block too. This checks the bad_tags
  # list set up below and returns the HTML escaped result. Otherwise it
  # lets it through. That way, we turn white listing into black listing,
  # as in general forum users are trusted, but in the last year or so a
  # number of spammers have got through the Hub captcha and shown that
  # users aren't quite as trustworthy as they used to be.

  WhiteListHelper.attributes = Set.new()
  WhiteListHelper.tags       = Set.new() # So everything is passed to the custom block as if 'bad'

  WhiteListHelper.bad_tags.merge(%w(object param embed frame iframe))

end
