xml.instruct! :xml, :version=>"1.0", :encoding=>"iso-8859-1"

if Rails.env.production?
  xml.error('Sorry, something went wrong. Please contact ROOL if this error persists via webmaster@riscosopen.org')
else
  xml.error_class(exception.class)
  xml.error(exception.message)
  xml.backtrace(exception.backtrace.join("\n"))
end
