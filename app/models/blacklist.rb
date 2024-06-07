# 2019-01-26 (ADH):
#
# Very simplistic quick-and-dirty implementation; Blacklist has just one
# row, which contains a text field of newline separated items processed
# by Ruby when checking a post. Not efficient but sufficient for now.
#
class Blacklist < ActiveRecord::Base

  before_save :downcase_and_strip

  protected

    def downcase_and_strip
      self.list       = tidy(self.list)
      self.title_list = tidy(self.title_list)
    end

  private

    def tidy(text)
      (text || '').split("\n").map { |item| item.strip.downcase }.join("\n")
    end

end
