EasyMailer.setup do |config|

  # Enable and setup default options for Tracker
  config.tracker.setup do |tracker_config|

    # Host used to build URL's to track clicks and opens. This value
    # is required unless you use Rails and you already set
    # Rails.configuration.action_mailer.default_url_options.host
    #
    # tracker_config.host = "http://tracker.example.com/"

  end

  # Enable and setup default options for Viewer
  config.viewer.setup do |viewer_config|

    # Use FilesAdapter
    #
    #viewer_config.adapter = :files

    # Use ActiveRecordAdapter
    #
    # == example
    #
    # viewer_config.adapter = :active_record, {
    #   # An ActiveRecord subclass. Must have a primary key
    #   model: EasyMailer::MailModel,
    #
    #   # Matching between attributes used by EasyMailer Viewer adapter and
    #   # specified model attributes. If attribute is not specified in this matching,
    #   # default value is used
    #   attributes: {
    #     # Must be a text attribute. It's used to store the content of the Message
    #     message: :message,
    #
    #     # Must be a string attribute.
    #     message_id: :message_id,
    #
    #     # Must be a nullable string attribute
    #     mailer: :mailer,
    #
    #     # Must be a nullable string attribute
    #     model: :model
    #   }
    # }
    #
    viewer_config.adapter = :active_record

  end

end