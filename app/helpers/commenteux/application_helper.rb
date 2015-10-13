module Commenteux
  module ApplicationHelper
    def icon(klass_ending, title='')
      "<i class='icon-#{klass_ending}'></i> #{title}".html_safe
    end
  end
end
