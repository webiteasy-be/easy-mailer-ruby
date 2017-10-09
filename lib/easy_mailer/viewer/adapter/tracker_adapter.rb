module EasyMailer
  module Viewer
    module Adapter
      class FilesAdapter

        def initialize(options={})
          @options = { }.merge(options)
        end

        def process(mail, processor_options)
          mail['Easy-Mailer-Mailer'] ||= mailer.action_name
          mail['Easy-Mailer-Model'] ||=  mailer.class.name.underscore
        end

        # options.mailer
        # options.model
        # options.recipient
        # options.mail_id
        def where(filters={})
          # TODO
        end

        def find(mail_id)
          # TODO
        end
      end
    end
  end
end