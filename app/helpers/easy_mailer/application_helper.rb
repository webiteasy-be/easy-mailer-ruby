module EasyMailer
  module ApplicationHelper
    def content_type_to_part_type(str)
      case str
        when /^multipart\/alternative/
          'multipart'
        when /^text\/plain/
          'text'
        when /^text\/html/
          'html'
        else
          nil
      end
    end
  end
end
